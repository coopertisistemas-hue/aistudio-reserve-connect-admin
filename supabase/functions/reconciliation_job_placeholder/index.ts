import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type, x-session-id, x-idempotency-key',
}

const supabaseAdmin = createClient(
  Deno.env.get('SUPABASE_URL') ?? '',
  Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
)

async function fetchSummary() {
  const { data, error } = await supabaseAdmin.rpc('reconciliation_summary')
  if (error) {
    throw new Error(`Failed to fetch summary: ${error.message}`)
  }
  return data as Record<string, unknown>
}

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  if (req.method !== 'POST') {
    return new Response(
      JSON.stringify({ success: false, error: { code: 'RESERVE_001', message: 'Method not allowed' } }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 405 }
    )
  }

  try {
    const body = await req.json().catch(() => ({}))
    const runId = body?.run_id || `recon_${crypto.randomUUID()}`
    const dryRun = body?.dry_run === true

    const summary = await fetchSummary()

    if (!dryRun) {
      const { error } = await supabaseAdmin.rpc('log_reconciliation_run', {
        p_run_id: runId,
        p_status: 'completed',
        p_summary: summary,
        p_started_at: new Date().toISOString(),
        p_completed_at: new Date().toISOString()
      })

      if (error) {
        throw new Error(`Failed to log reconciliation run: ${error.message}`)
      }
    }

    return new Response(
      JSON.stringify({ success: true, data: { run_id: runId, dry_run: dryRun, summary } }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  } catch (error) {
    console.error('Error in reconciliation_job_placeholder:', error)
    return new Response(
      JSON.stringify({ success: false, error: { code: 'RESERVE_010', message: error.message } }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 500 }
    )
  }
})
