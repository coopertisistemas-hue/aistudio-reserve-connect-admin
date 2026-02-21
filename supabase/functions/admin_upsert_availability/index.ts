import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import { requireAdmin, corsHeaders, createErrorResponse, createSuccessResponse } from '../_shared/auth.ts'

const supabaseAdmin = createClient(
  Deno.env.get('SUPABASE_URL') ?? '',
  Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
)

type AvailabilityInput = {
  unit_id: string
  rate_plan_id: string
  date: string
  is_available?: boolean
  is_blocked?: boolean
  block_reason?: string | null
  min_stay_override?: number | null
  base_price: number
  discounted_price?: number | null
  currency?: string
  allotment?: number
}

function normalizeRow(row: AvailabilityInput) {
  const basePrice = Number(row.base_price)
  const discountedPrice = row.discounted_price === undefined || row.discounted_price === null
    ? null
    : Number(row.discounted_price)

  if (!row.unit_id || !row.rate_plan_id || !row.date) {
    throw new Error('unit_id, rate_plan_id and date are required')
  }
  if (!Number.isFinite(basePrice) || basePrice < 0) {
    throw new Error('base_price must be a valid number >= 0')
  }
  if (discountedPrice !== null && (!Number.isFinite(discountedPrice) || discountedPrice < 0 || discountedPrice > basePrice)) {
    throw new Error('discounted_price must be between 0 and base_price')
  }

  return {
    unit_id: row.unit_id,
    rate_plan_id: row.rate_plan_id,
    date: row.date,
    is_available: row.is_available !== false,
    is_blocked: row.is_blocked === true,
    block_reason: row.block_reason || null,
    min_stay_override: row.min_stay_override ?? null,
    base_price: basePrice,
    discounted_price: discountedPrice,
    currency: row.currency || 'BRL',
    allotment: row.allotment ?? 1,
  }
}

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    await requireAdmin(req, supabaseAdmin)

    const body = await req.json().catch(() => ({}))
    const rowsInput = Array.isArray(body?.rows)
      ? body.rows
      : body?.unit_id
        ? [body]
        : []

    if (!rowsInput.length) {
      throw new Error('rows payload is required')
    }

    const rows = rowsInput.map((row: AvailabilityInput) => normalizeRow(row))

    const { data, error } = await supabaseAdmin
      .rpc('admin_s1_upsert_availability_rows', { p_rows: rows })

    if (error) throw error

    return createSuccessResponse({
      updated_count: data?.length || 0,
      rows: data || [],
    })
  } catch (error) {
    console.error('admin_upsert_availability error:', (error as Error).message)
    return createErrorResponse('ADMIN_AVAILABILITY_002', (error as Error).message, 400)
  }
})
