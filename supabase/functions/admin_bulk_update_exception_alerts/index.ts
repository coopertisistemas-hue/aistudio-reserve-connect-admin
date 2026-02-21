import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import { requireAdmin, corsHeaders, createErrorResponse, createSuccessResponse } from '../_shared/auth.ts'

const supabaseAdmin = createClient(
  Deno.env.get('SUPABASE_URL') ?? '',
  Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
)

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    await requireAdmin(req, supabaseAdmin)

    const body = await req.json().catch(() => ({}))
    const alertCodes = Array.isArray(body?.alert_codes)
      ? body.alert_codes.map((value: unknown) => String(value).trim()).filter(Boolean)
      : []

    if (!alertCodes.length) {
      throw new Error('alert_codes is required')
    }

    const { data, error } = await supabaseAdmin.rpc('admin_ops_alert_bulk_update', {
      p_alert_codes: alertCodes,
      p_status: (body?.status as string | undefined)?.trim().toLowerCase() || null,
      p_owner_email: body?.owner_email ?? null,
      p_priority: (body?.priority as string | undefined)?.trim().toLowerCase() || null,
      p_note: body?.note ?? null,
      p_snoozed_until: body?.snoozed_until ?? null,
    })

    if (error) {
      throw error
    }

    return createSuccessResponse(data || [])
  } catch (error) {
    console.error('admin_bulk_update_exception_alerts error:', (error as Error).message)
    return createErrorResponse('ADMIN_OPS_QUEUE_003', (error as Error).message, 400)
  }
})
