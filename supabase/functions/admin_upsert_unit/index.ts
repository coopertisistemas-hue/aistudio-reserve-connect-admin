import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import { requireAdmin, corsHeaders, createErrorResponse, createSuccessResponse } from '../_shared/auth.ts'

const supabaseAdmin = createClient(
  Deno.env.get('SUPABASE_URL') ?? '',
  Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
)

function normalizeSlug(value: string) {
  return value
    .trim()
    .toLowerCase()
    .normalize('NFD')
    .replace(/[^a-z0-9\s-]/g, '')
    .replace(/\s+/g, '-')
    .replace(/-+/g, '-')
}

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    await requireAdmin(req, supabaseAdmin)

    const body = await req.json()
    const id = (body?.id as string | undefined)?.trim()
    const propertyId = (body?.property_id as string | undefined)?.trim()
    const name = (body?.name as string | undefined)?.trim()

    if (!propertyId) throw new Error('property_id is required')
    if (!name) throw new Error('name is required')

    const slug = normalizeSlug((body?.slug as string | undefined)?.trim() || name)
    const maxOccupancy = Number(body?.max_occupancy ?? 2)
    const baseCapacity = Number(body?.base_capacity ?? Math.min(maxOccupancy, 2))

    if (!Number.isFinite(maxOccupancy) || maxOccupancy < 1) {
      throw new Error('max_occupancy must be >= 1')
    }
    if (!Number.isFinite(baseCapacity) || baseCapacity < 1) {
      throw new Error('base_capacity must be >= 1')
    }
    if (baseCapacity > maxOccupancy) {
      throw new Error('base_capacity cannot be greater than max_occupancy')
    }

    const payload = {
      property_id: propertyId,
      host_property_id: body?.host_property_id || null,
      host_unit_id: body?.host_unit_id || crypto.randomUUID(),
      name,
      slug,
      unit_type: body?.unit_type || null,
      description: body?.description || null,
      max_occupancy: maxOccupancy,
      base_capacity: baseCapacity,
      size_sqm: body?.size_sqm ?? null,
      bed_configuration: body?.bed_configuration ?? [],
      amenities_cached: body?.amenities_cached ?? [],
      images_cached: body?.images_cached ?? [],
      is_active: body?.is_active !== false,
    }

    if (id) {
      const { data, error } = await supabaseAdmin
        .from('unit_map')
        .update(payload)
        .eq('id', id)
        .select('id, property_id, name, slug, unit_type, max_occupancy, base_capacity, size_sqm, is_active, updated_at')
        .single()

      if (error) throw error
      return createSuccessResponse({ mode: 'updated', unit: data })
    }

    const { data, error } = await supabaseAdmin
      .from('unit_map')
      .insert(payload)
      .select('id, property_id, name, slug, unit_type, max_occupancy, base_capacity, size_sqm, is_active, created_at')
      .single()

    if (error) throw error
    return createSuccessResponse({ mode: 'created', unit: data })
  } catch (error) {
    console.error('admin_upsert_unit error:', (error as Error).message)
    return createErrorResponse('ADMIN_UNITS_002', (error as Error).message, 400)
  }
})
