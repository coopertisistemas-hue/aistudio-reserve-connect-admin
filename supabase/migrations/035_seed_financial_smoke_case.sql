-- ============================================
-- MIGRATION 035: SEED FINANCIAL SMOKE CASE
-- Description: Seed one payment, payout, and ledger transactions for admin smoke tests
-- ============================================

DO $$
DECLARE
    v_city_exists BOOLEAN;
    v_property_id UUID;
BEGIN
    SELECT EXISTS(SELECT 1 FROM reserve.cities WHERE code = 'URB') INTO v_city_exists;

    IF NOT v_city_exists THEN
        RAISE NOTICE 'Skipping financial seed: city URB not found';
        RETURN;
    END IF;

    INSERT INTO reserve.payments (
        id,
        reservation_id,
        booking_intent_id,
        city_code,
        payment_method,
        gateway,
        gateway_payment_id,
        currency,
        amount,
        gateway_fee,
        tax_amount,
        status,
        refunded_amount,
        idempotency_key,
        metadata,
        created_at,
        updated_at,
        succeeded_at,
        refunded_at
    ) VALUES (
        '7f9b9014-7307-45a7-8cf1-2b2c7777a241',
        NULL,
        NULL,
        'URB',
        'stripe_card',
        'stripe',
        'pi_seed_financial_smoke_001',
        'BRL',
        200,
        8,
        0,
        'partially_refunded',
        50,
        'seed_financial_smoke_case_20260219',
        '{"seed": true, "scenario": "financial_smoke_case"}'::jsonb,
        NOW() - INTERVAL '1 day',
        NOW() - INTERVAL '6 hours',
        NOW() - INTERVAL '1 day',
        NOW() - INTERVAL '6 hours'
    )
    ON CONFLICT (id) DO NOTHING;

    INSERT INTO reserve.ledger_entries (
        id,
        transaction_id,
        entry_type,
        booking_id,
        city_code,
        payment_id,
        account,
        counterparty,
        direction,
        amount,
        description,
        created_at
    ) VALUES
    (
        '2c91d8c5-5a7e-4f21-a7ea-0fcd3ec95101',
        'e9228947-6954-4568-90a7-2d8d6c0a1111',
        'payment_received',
        NULL,
        'URB',
        '7f9b9014-7307-45a7-8cf1-2b2c7777a241',
        'cash_reserve',
        'customer',
        'debit',
        200,
        'Seed smoke: payment debit',
        NOW() - INTERVAL '1 day'
    ),
    (
        '2c91d8c5-5a7e-4f21-a7ea-0fcd3ec95102',
        'e9228947-6954-4568-90a7-2d8d6c0a1111',
        'payment_received',
        NULL,
        'URB',
        '7f9b9014-7307-45a7-8cf1-2b2c7777a241',
        'customer_deposits',
        'customer',
        'credit',
        200,
        'Seed smoke: payment credit',
        NOW() - INTERVAL '1 day'
    ),
    (
        '2c91d8c5-5a7e-4f21-a7ea-0fcd3ec95103',
        'e9228947-6954-4568-90a7-2d8d6c0a2222',
        'refund_processed',
        NULL,
        'URB',
        '7f9b9014-7307-45a7-8cf1-2b2c7777a241',
        'refunds_payable',
        'customer',
        'debit',
        50,
        'Seed smoke: refund debit',
        NOW() - INTERVAL '6 hours'
    ),
    (
        '2c91d8c5-5a7e-4f21-a7ea-0fcd3ec95104',
        'e9228947-6954-4568-90a7-2d8d6c0a2222',
        'refund_processed',
        NULL,
        'URB',
        '7f9b9014-7307-45a7-8cf1-2b2c7777a241',
        'cash_reserve',
        'customer',
        'credit',
        50,
        'Seed smoke: refund credit',
        NOW() - INTERVAL '6 hours'
    )
    ON CONFLICT (id) DO NOTHING;

    SELECT id
    INTO v_property_id
    FROM reserve.properties_map
    WHERE city_code = 'URB'
    ORDER BY created_at ASC
    LIMIT 1;

    IF v_property_id IS NOT NULL THEN
        INSERT INTO reserve.payouts (
            id,
            batch_id,
            city_code,
            property_id,
            owner_id,
            currency,
            gross_amount,
            commission_amount,
            fee_amount,
            tax_amount,
            net_amount,
            status,
            gateway_reference,
            gateway_transfer_id,
            booking_count,
            reservation_ids,
            created_at,
            updated_at,
            processed_at,
            transferred_at
        ) VALUES (
            '49dbf79f-4d4f-4706-bfcf-aaf8865c9b51',
            NULL,
            'URB',
            v_property_id,
            NULL,
            'BRL',
            120,
            18,
            2,
            0,
            100,
            'completed',
            'seed_payout_ref_001',
            'seed_payout_transfer_001',
            1,
            '[]'::jsonb,
            NOW() - INTERVAL '3 days',
            NOW() - INTERVAL '2 days',
            NOW() - INTERVAL '2 days',
            NOW() - INTERVAL '2 days'
        )
        ON CONFLICT (id) DO NOTHING;
    ELSE
        RAISE NOTICE 'Skipping payout seed: no property found for URB';
    END IF;
END $$;
