import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

const supabaseAdmin = createClient(
  Deno.env.get('SUPABASE_URL') ?? '',
  Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
)

async function countRows(table: string, filter: (query: any) => any) {
  const query = filter(supabaseAdmin.from(table).select('id', { count: 'exact', head: true }))
  const { count } = await query
  return count ?? 0
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

    const oneHourAgo = new Date(Date.now() - 60 * 60 * 1000).toISOString()
    const fifteenMinutesAgo = new Date(Date.now() - 15 * 60 * 1000).toISOString()
    const tenMinutesAgo = new Date(Date.now() - 10 * 60 * 1000).toISOString()

    const stuckPayments = await countRows('payments', (query) =>
      query.in('status', ['pending', 'processing']).lt('created_at', oneHourAgo)
    )

    const missingFinalization = await countRows('booking_intents', (query) =>
      query.eq('status', 'payment_confirmed').is('converted_to_reservation_id', null).lt('created_at', tenMinutesAgo)
    )

    const pendingWebhooks = await countRows('host_webhook_events', (query) =>
      query.in('status', ['pending', 'failed']).lt('created_at', fifteenMinutesAgo)
    )

    const pendingCancellations = await countRows('cancellation_requests', (query) =>
      query.eq('status', 'processing').lt('created_at', fifteenMinutesAgo)
    )

    const summary = {
      stuck_payments: stuckPayments,
      missing_finalization: missingFinalization,
      pending_webhooks: pendingWebhooks,
      pending_cancellations: pendingCancellations,
      generated_at: new Date().toISOString()
    }

    if (!dryRun) {
      const { error } = await supabaseAdmin
        .from('reconciliation_runs')
        .insert({
          run_id: runId,
          status: 'completed',
          summary,
          started_at: new Date().toISOString(),
          completed_at: new Date().toISOString()
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
