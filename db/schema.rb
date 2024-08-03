# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 0) do
  create_schema "hdb_catalog"
  create_schema "pgboss"

  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_stat_statements"
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "rewardtype", ["leader", "member", "reserves", "treasury", "refund"]
  create_enum "scriptpurposetype", ["spend", "mint", "cert", "reward"]
  create_enum "scripttype", ["multisig", "timelock", "plutusV1", "plutusV2"]
  create_enum "syncstatetype", ["lagging", "following"]

  create_table "Asset", primary_key: "assetId", id: :binary, force: :cascade do |t|
    t.binary "assetName"
    t.integer "decimals"
    t.string "description"
    t.string "fingerprint", limit: 44
    t.integer "firstAppearedInSlot"
    t.string "logo"
    t.string "metadataHash", limit: 40
    t.string "name"
    t.binary "policyId"
    t.string "ticker", limit: 9
    t.string "url"
  end

  create_table "ada_pots", force: :cascade do |t|
    t.integer "slot_no", limit: 8, null: false
    t.integer "epoch_no", null: false
    t.decimal "treasury", null: false
    t.decimal "reserves", null: false
    t.decimal "rewards", null: false
    t.decimal "utxo", null: false
    t.decimal "deposits", null: false
    t.decimal "fees", null: false
    t.bigint "block_id", null: false
    t.index ["block_id"], name: "unique_ada_pots", unique: true
  end

  create_table "block", force: :cascade do |t|
    t.binary "hash", null: false
    t.integer "epoch_no"
    t.integer "slot_no", limit: 8
    t.integer "epoch_slot_no"
    t.integer "block_no"
    t.bigint "previous_id"
    t.bigint "slot_leader_id", null: false
    t.integer "size", null: false
    t.datetime "time", precision: nil, null: false
    t.bigint "tx_count", null: false
    t.integer "proto_major", null: false
    t.integer "proto_minor", null: false
    t.string "vrf_key"
    t.binary "op_cert"
    t.integer "op_cert_counter", limit: 8
    t.index "encode((hash)::bytea, 'hex'::text)", name: "bf_idx_block_hash_encoded", using: :hash
    t.index ["block_no"], name: "idx_block_block_no"
    t.index ["epoch_no"], name: "idx_block_epoch_no"
    t.index ["hash"], name: "idx_block_hash"
    t.index ["previous_id"], name: "idx_block_previous_id"
    t.index ["slot_leader_id"], name: "idx_block_slot_leader_id"
    t.index ["slot_no"], name: "idx_block_slot_no"
    t.index ["time"], name: "idx_block_time"
    t.unique_constraint ["hash"], name: "unique_block"
  end

  create_table "collateral_tx_in", force: :cascade do |t|
    t.bigint "tx_in_id", null: false
    t.bigint "tx_out_id", null: false
    t.integer "tx_out_index", limit: 2, null: false
    t.index ["tx_in_id", "tx_out_id", "tx_out_index"], name: "unique_col_txin", unique: true
    t.index ["tx_out_id"], name: "idx_collateral_tx_in_tx_out_id"
  end

  create_table "collateral_tx_out", force: :cascade do |t|
    t.bigint "tx_id", null: false
    t.integer "index", limit: 2, null: false
    t.string "address", null: false
    t.binary "address_raw", null: false
    t.boolean "address_has_script", null: false
    t.binary "payment_cred"
    t.bigint "stake_address_id"
    t.decimal "value", null: false
    t.binary "data_hash"
    t.string "multi_assets_descr", null: false
    t.bigint "inline_datum_id"
    t.bigint "reference_script_id"
    t.index ["inline_datum_id"], name: "collateral_tx_out_inline_datum_id_idx"
    t.index ["reference_script_id"], name: "collateral_tx_out_reference_script_id_idx"
    t.index ["stake_address_id"], name: "collateral_tx_out_stake_address_id_idx"
    t.index ["tx_id", "index"], name: "unique_col_txout", unique: true
  end

  create_table "cost_model", force: :cascade do |t|
    t.jsonb "costs", null: false
    t.binary "hash", null: false

    t.unique_constraint ["hash"], name: "unique_cost_model"
  end

  create_table "datum", force: :cascade do |t|
    t.binary "hash", null: false
    t.bigint "tx_id", null: false
    t.jsonb "value"
    t.binary "bytes", null: false
    t.index "encode((hash)::bytea, 'hex'::text)", name: "bf_idx_datum_hash", using: :hash
    t.index ["tx_id"], name: "idx_datum_tx_id"
    t.unique_constraint ["hash"], name: "unique_datum"
  end

  create_table "delegation", force: :cascade do |t|
    t.bigint "addr_id", null: false
    t.integer "cert_index", null: false
    t.bigint "pool_hash_id", null: false
    t.bigint "active_epoch_no", null: false
    t.bigint "tx_id", null: false
    t.integer "slot_no", limit: 8, null: false
    t.bigint "redeemer_id"
    t.index ["active_epoch_no"], name: "idx_delegation_active_epoch_no"
    t.index ["addr_id"], name: "idx_delegation_addr_id"
    t.index ["pool_hash_id"], name: "idx_delegation_pool_hash_id"
    t.index ["redeemer_id"], name: "idx_delegation_redeemer_id"
    t.index ["tx_id", "cert_index"], name: "unique_delegation", unique: true
    t.index ["tx_id"], name: "idx_delegation_tx_id"
  end

  create_table "delisted_pool", force: :cascade do |t|
    t.binary "hash_raw", null: false

    t.unique_constraint ["hash_raw"], name: "unique_delisted_pool"
  end

  create_table "epoch", force: :cascade do |t|
    t.decimal "out_sum", null: false
    t.decimal "fees", null: false
    t.integer "tx_count", null: false
    t.integer "blk_count", null: false
    t.integer "no", null: false
    t.datetime "start_time", precision: nil, null: false
    t.datetime "end_time", precision: nil, null: false
    t.index ["no"], name: "idx_epoch_no"
    t.unique_constraint ["no"], name: "unique_epoch"
  end

  create_table "epoch_param", force: :cascade do |t|
    t.integer "epoch_no", null: false
    t.integer "min_fee_a", null: false
    t.integer "min_fee_b", null: false
    t.integer "max_block_size", null: false
    t.integer "max_tx_size", null: false
    t.integer "max_bh_size", null: false
    t.decimal "key_deposit", null: false
    t.decimal "pool_deposit", null: false
    t.integer "max_epoch", null: false
    t.integer "optimal_pool_count", null: false
    t.float "influence", null: false
    t.float "monetary_expand_rate", null: false
    t.float "treasury_growth_rate", null: false
    t.float "decentralisation", null: false
    t.integer "protocol_major", null: false
    t.integer "protocol_minor", null: false
    t.decimal "min_utxo_value", null: false
    t.decimal "min_pool_cost", null: false
    t.binary "nonce"
    t.bigint "cost_model_id"
    t.float "price_mem"
    t.float "price_step"
    t.decimal "max_tx_ex_mem"
    t.decimal "max_tx_ex_steps"
    t.decimal "max_block_ex_mem"
    t.decimal "max_block_ex_steps"
    t.decimal "max_val_size"
    t.integer "collateral_percent"
    t.integer "max_collateral_inputs"
    t.bigint "block_id", null: false
    t.binary "extra_entropy"
    t.decimal "coins_per_utxo_size"
    t.index ["block_id"], name: "idx_epoch_param_block_id"
    t.index ["cost_model_id"], name: "idx_epoch_param_cost_model_id"
    t.index ["epoch_no", "block_id"], name: "unique_epoch_param", unique: true
  end

  create_table "epoch_stake", force: :cascade do |t|
    t.bigint "addr_id", null: false
    t.bigint "pool_id", null: false
    t.decimal "amount", null: false
    t.integer "epoch_no", null: false
    t.index ["addr_id"], name: "idx_epoch_stake_addr_id"
    t.index ["epoch_no", "id"], name: "bf_u_idx_epoch_stake_epoch_and_id", unique: true
    t.index ["epoch_no"], name: "idx_epoch_stake_epoch_no"
    t.index ["pool_id"], name: "idx_epoch_stake_pool_id"
    t.unique_constraint ["epoch_no", "addr_id", "pool_id"], name: "unique_stake"
  end

  create_table "epoch_sync_time", force: :cascade do |t|
    t.bigint "no", null: false
    t.integer "seconds", limit: 8, null: false
    t.enum "state", null: false, enum_type: "syncstatetype"

    t.unique_constraint ["no"], name: "unique_epoch_sync_time"
  end

  create_table "extra_key_witness", force: :cascade do |t|
    t.binary "hash", null: false
    t.bigint "tx_id", null: false
    t.index ["tx_id"], name: "idx_extra_key_witness_tx_id"
  end

  create_table "ma_tx_mint", force: :cascade do |t|
    t.decimal "quantity", null: false
    t.bigint "tx_id", null: false
    t.bigint "ident", null: false
    t.index ["ident", "tx_id"], name: "unique_ma_tx_mint", unique: true
    t.index ["tx_id"], name: "idx_ma_tx_mint_tx_id"
  end

  create_table "ma_tx_out", force: :cascade do |t|
    t.decimal "quantity", null: false
    t.bigint "tx_out_id", null: false
    t.bigint "ident", null: false
    t.index ["ident", "tx_out_id"], name: "unique_ma_tx_out", unique: true
    t.index ["ident"], name: "idx_ident"
    t.index ["tx_out_id"], name: "idx_ma_tx_out_tx_out_id"
  end

  create_table "meta", force: :cascade do |t|
    t.datetime "start_time", precision: nil, null: false
    t.string "network_name", null: false
    t.string "version", null: false

    t.unique_constraint ["start_time"], name: "unique_meta"
  end

  create_table "multi_asset", force: :cascade do |t|
    t.binary "policy", null: false
    t.binary "name", null: false
    t.string "fingerprint", null: false
    t.index "(((policy)::bytea || (name)::bytea))", name: "idx_asset_id"
    t.index "((encode((policy)::bytea, 'hex'::text) || encode((name)::bytea, 'hex'::text)))", name: "bf_idx_multi_asset_policy_name", using: :hash
    t.index "encode((policy)::bytea, 'hex'::text)", name: "bf_idx_multi_asset_policy", using: :hash
    t.index ["fingerprint"], name: "multi_asset_fingerprint"
    t.index ["name"], name: "idx_multi_asset_name"
    t.index ["policy"], name: "idx_multi_asset_policy"
    t.unique_constraint ["policy", "name"], name: "unique_multi_asset"
  end

  create_table "param_proposal", force: :cascade do |t|
    t.integer "epoch_no", null: false
    t.binary "key", null: false
    t.decimal "min_fee_a"
    t.decimal "min_fee_b"
    t.decimal "max_block_size"
    t.decimal "max_tx_size"
    t.decimal "max_bh_size"
    t.decimal "key_deposit"
    t.decimal "pool_deposit"
    t.decimal "max_epoch"
    t.decimal "optimal_pool_count"
    t.float "influence"
    t.float "monetary_expand_rate"
    t.float "treasury_growth_rate"
    t.float "decentralisation"
    t.binary "entropy"
    t.integer "protocol_major"
    t.integer "protocol_minor"
    t.decimal "min_utxo_value"
    t.decimal "min_pool_cost"
    t.bigint "cost_model_id"
    t.float "price_mem"
    t.float "price_step"
    t.decimal "max_tx_ex_mem"
    t.decimal "max_tx_ex_steps"
    t.decimal "max_block_ex_mem"
    t.decimal "max_block_ex_steps"
    t.decimal "max_val_size"
    t.integer "collateral_percent"
    t.integer "max_collateral_inputs"
    t.bigint "registered_tx_id", null: false
    t.decimal "coins_per_utxo_size"
    t.index ["cost_model_id"], name: "idx_param_proposal_cost_model_id"
    t.index ["key", "registered_tx_id"], name: "unique_param_proposal", unique: true
    t.index ["registered_tx_id"], name: "idx_param_proposal_registered_tx_id"
  end

  create_table "pool_hash", force: :cascade do |t|
    t.binary "hash_raw", null: false
    t.string "view", null: false
    t.index ["view"], name: "bf_idx_pool_hash_view", using: :hash
    t.unique_constraint ["hash_raw"], name: "unique_pool_hash"
  end

  create_table "pool_metadata_ref", force: :cascade do |t|
    t.bigint "pool_id", null: false
    t.string "url", null: false
    t.binary "hash", null: false
    t.bigint "registered_tx_id", null: false
    t.index ["pool_id"], name: "idx_pool_metadata_ref_pool_id"
    t.index ["registered_tx_id"], name: "idx_pool_metadata_ref_registered_tx_id"
    t.unique_constraint ["pool_id", "url", "hash"], name: "unique_pool_metadata_ref"
  end

  create_table "pool_offline_data", force: :cascade do |t|
    t.bigint "pool_id", null: false
    t.string "ticker_name", null: false
    t.binary "hash", null: false
    t.jsonb "json", null: false
    t.binary "bytes", null: false
    t.bigint "pmr_id", null: false
    t.index ["pmr_id"], name: "idx_pool_offline_data_pmr_id"
    t.unique_constraint ["pool_id", "hash"], name: "unique_pool_offline_data"
  end

  create_table "pool_offline_fetch_error", force: :cascade do |t|
    t.bigint "pool_id", null: false
    t.datetime "fetch_time", precision: nil, null: false
    t.bigint "pmr_id", null: false
    t.string "fetch_error", null: false
    t.integer "retry_count", null: false
    t.index ["pmr_id"], name: "idx_pool_offline_fetch_error_pmr_id"
    t.unique_constraint ["pool_id", "fetch_time", "retry_count"], name: "unique_pool_offline_fetch_error"
  end

  create_table "pool_owner", force: :cascade do |t|
    t.bigint "addr_id", null: false
    t.bigint "pool_update_id", null: false
    t.index ["addr_id", "pool_update_id"], name: "unique_pool_owner", unique: true
    t.index ["pool_update_id"], name: "pool_owner_pool_update_id_idx"
  end

  create_table "pool_relay", force: :cascade do |t|
    t.bigint "update_id", null: false
    t.string "ipv4"
    t.string "ipv6"
    t.string "dns_name"
    t.string "dns_srv_name"
    t.integer "port"
    t.index ["update_id", "ipv4", "ipv6", "dns_name"], name: "unique_pool_relay", unique: true
    t.index ["update_id"], name: "idx_pool_relay_update_id"
  end

  create_table "pool_retire", force: :cascade do |t|
    t.bigint "hash_id", null: false
    t.integer "cert_index", null: false
    t.bigint "announced_tx_id", null: false
    t.integer "retiring_epoch", null: false
    t.index ["announced_tx_id", "cert_index"], name: "unique_pool_retiring", unique: true
    t.index ["announced_tx_id"], name: "idx_pool_retire_announced_tx_id"
    t.index ["hash_id"], name: "idx_pool_retire_hash_id"
  end

  create_table "pool_update", force: :cascade do |t|
    t.bigint "hash_id", null: false
    t.integer "cert_index", null: false
    t.binary "vrf_key_hash", null: false
    t.decimal "pledge", null: false
    t.bigint "active_epoch_no", null: false
    t.bigint "meta_id"
    t.float "margin", null: false
    t.decimal "fixed_cost", null: false
    t.bigint "registered_tx_id", null: false
    t.bigint "reward_addr_id", null: false
    t.index ["active_epoch_no"], name: "idx_pool_update_active_epoch_no"
    t.index ["hash_id"], name: "idx_pool_update_hash_id"
    t.index ["meta_id"], name: "idx_pool_update_meta_id"
    t.index ["registered_tx_id", "cert_index"], name: "unique_pool_update", unique: true
    t.index ["registered_tx_id"], name: "idx_pool_update_registered_tx_id"
    t.index ["reward_addr_id"], name: "idx_pool_update_reward_addr"
  end

  create_table "pot_transfer", force: :cascade do |t|
    t.integer "cert_index", null: false
    t.decimal "treasury", null: false
    t.decimal "reserves", null: false
    t.bigint "tx_id", null: false
    t.index ["tx_id", "cert_index"], name: "unique_pot_transfer", unique: true
  end

  create_table "redeemer", force: :cascade do |t|
    t.bigint "tx_id", null: false
    t.integer "unit_mem", limit: 8, null: false
    t.integer "unit_steps", limit: 8, null: false
    t.decimal "fee"
    t.enum "purpose", null: false, enum_type: "scriptpurposetype"
    t.integer "index", null: false
    t.binary "script_hash"
    t.bigint "redeemer_data_id", null: false
    t.index ["redeemer_data_id"], name: "redeemer_redeemer_data_id_idx"
    t.index ["tx_id", "purpose", "index"], name: "unique_redeemer", unique: true
  end

  create_table "redeemer_data", force: :cascade do |t|
    t.binary "hash", null: false
    t.bigint "tx_id", null: false
    t.jsonb "value"
    t.binary "bytes", null: false
    t.index "encode((hash)::bytea, 'hex'::text)", name: "bf_idx_redeemer_data_hash", using: :hash
    t.index ["tx_id"], name: "redeemer_data_tx_id_idx"
    t.unique_constraint ["hash"], name: "unique_redeemer_data"
  end

  create_table "reference_tx_in", force: :cascade do |t|
    t.bigint "tx_in_id", null: false
    t.bigint "tx_out_id", null: false
    t.integer "tx_out_index", limit: 2, null: false
    t.index ["tx_in_id", "tx_out_id", "tx_out_index"], name: "unique_ref_txin", unique: true
    t.index ["tx_out_id"], name: "reference_tx_in_tx_out_id_idx"
  end

  create_table "reserve", force: :cascade do |t|
    t.bigint "addr_id", null: false
    t.integer "cert_index", null: false
    t.decimal "amount", null: false
    t.bigint "tx_id", null: false
    t.index ["addr_id", "tx_id", "cert_index"], name: "unique_reserves", unique: true
    t.index ["addr_id"], name: "idx_reserve_addr_id"
    t.index ["tx_id"], name: "idx_reserve_tx_id"
  end

  create_table "reserved_pool_ticker", force: :cascade do |t|
    t.string "name", null: false
    t.binary "pool_hash", null: false
    t.index ["pool_hash"], name: "idx_reserved_pool_ticker_pool_hash"
    t.unique_constraint ["name"], name: "unique_reserved_pool_ticker"
  end

  create_table "reverse_index", force: :cascade do |t|
    t.bigint "block_id", null: false
    t.string "min_ids"
  end

  create_table "reward", force: :cascade do |t|
    t.bigint "addr_id", null: false
    t.enum "type", null: false, enum_type: "rewardtype"
    t.decimal "amount", null: false
    t.bigint "earned_epoch", null: false
    t.bigint "spendable_epoch", null: false
    t.bigint "pool_id"
    t.index ["addr_id"], name: "idx_reward_addr_id"
    t.index ["earned_epoch"], name: "idx_reward_earned_epoch"
    t.index ["pool_id"], name: "idx_reward_pool_id"
    t.index ["spendable_epoch"], name: "idx_reward_spendable_epoch"
    t.index ["type"], name: "idx_reward_type"
    t.unique_constraint ["addr_id", "type", "earned_epoch", "pool_id"], name: "unique_reward"
  end

  create_table "schema_version", force: :cascade do |t|
    t.bigint "stage_one", null: false
    t.bigint "stage_two", null: false
    t.bigint "stage_three", null: false
  end

  create_table "script", force: :cascade do |t|
    t.bigint "tx_id", null: false
    t.binary "hash", null: false
    t.enum "type", null: false, enum_type: "scripttype"
    t.jsonb "json"
    t.binary "bytes"
    t.integer "serialised_size"
    t.index "encode((hash)::bytea, 'hex'::text)", name: "bf_idx_scripts_hash", using: :hash
    t.index ["tx_id"], name: "idx_script_tx_id"
    t.unique_constraint ["hash"], name: "unique_script"
  end

  create_table "slot_leader", force: :cascade do |t|
    t.binary "hash", null: false
    t.bigint "pool_hash_id"
    t.string "description", null: false
    t.index ["pool_hash_id"], name: "idx_slot_leader_pool_hash_id"
    t.unique_constraint ["hash"], name: "unique_slot_leader"
  end

  create_table "stake_address", force: :cascade do |t|
    t.binary "hash_raw", null: false
    t.string "view", null: false
    t.binary "script_hash"
    t.index ["hash_raw"], name: "idx_stake_address_hash_raw"
    t.index ["view"], name: "idx_stake_address_view", using: :hash
    t.unique_constraint ["hash_raw"], name: "unique_stake_address"
  end

  create_table "stake_deregistration", force: :cascade do |t|
    t.bigint "addr_id", null: false
    t.integer "cert_index", null: false
    t.integer "epoch_no", null: false
    t.bigint "tx_id", null: false
    t.bigint "redeemer_id"
    t.index ["addr_id"], name: "idx_stake_deregistration_addr_id"
    t.index ["redeemer_id"], name: "idx_stake_deregistration_redeemer_id"
    t.index ["tx_id", "cert_index"], name: "unique_stake_deregistration", unique: true
    t.index ["tx_id"], name: "idx_stake_deregistration_tx_id"
  end

  create_table "stake_registration", force: :cascade do |t|
    t.bigint "addr_id", null: false
    t.integer "cert_index", null: false
    t.integer "epoch_no", null: false
    t.bigint "tx_id", null: false
    t.index ["addr_id"], name: "idx_stake_registration_addr_id"
    t.index ["tx_id", "cert_index"], name: "unique_stake_registration", unique: true
    t.index ["tx_id"], name: "idx_stake_registration_tx_id"
  end

  create_table "treasury", force: :cascade do |t|
    t.bigint "addr_id", null: false
    t.integer "cert_index", null: false
    t.decimal "amount", null: false
    t.bigint "tx_id", null: false
    t.index ["addr_id", "tx_id", "cert_index"], name: "unique_treasury", unique: true
    t.index ["addr_id"], name: "idx_treasury_addr_id"
    t.index ["tx_id"], name: "idx_treasury_tx_id"
  end

  create_table "tx", force: :cascade do |t|
    t.binary "hash", null: false
    t.bigint "block_id", null: false
    t.integer "block_index", null: false
    t.decimal "out_sum", null: false
    t.decimal "fee", null: false
    t.bigint "deposit", null: false
    t.integer "size", null: false
    t.decimal "invalid_before"
    t.decimal "invalid_hereafter"
    t.boolean "valid_contract", null: false
    t.integer "script_size", null: false
    t.index "encode((hash)::bytea, 'hex'::text)", name: "bf_idx_tx_hash", using: :hash
    t.index ["block_id"], name: "idx_tx_block_id"
    t.index ["hash"], name: "idx_tx_hash"
    t.index ["valid_contract"], name: "idx_tx_valid_contract"
    t.unique_constraint ["hash"], name: "unique_tx"
  end

  create_table "tx_in", force: :cascade do |t|
    t.bigint "tx_in_id", null: false
    t.bigint "tx_out_id", null: false
    t.integer "tx_out_index", limit: 2, null: false
    t.bigint "redeemer_id"
    t.index ["redeemer_id"], name: "idx_tx_in_redeemer_id"
    t.index ["tx_in_id"], name: "idx_tx_in_source_tx"
    t.index ["tx_in_id"], name: "idx_tx_in_tx_in_id"
    t.index ["tx_out_id", "tx_out_index"], name: "unique_txin", unique: true
    t.index ["tx_out_id"], name: "idx_tx_in_consuming_tx"
    t.index ["tx_out_id"], name: "idx_tx_in_tx_out_id"
  end

  create_table "tx_metadata", force: :cascade do |t|
    t.decimal "key", null: false
    t.jsonb "json"
    t.binary "bytes", null: false
    t.bigint "tx_id", null: false
    t.index "\"substring\"((json)::text, 2, 38) text_pattern_ops", name: "idx_tx_metadata_json_prefix"
    t.index ["key", "tx_id"], name: "unique_tx_metadata", unique: true
    t.index ["tx_id"], name: "idx_tx_metadata_tx_id"
  end

  create_table "tx_out", force: :cascade do |t|
    t.bigint "tx_id", null: false
    t.integer "index", limit: 2, null: false
    t.string "address", null: false
    t.binary "address_raw", null: false
    t.boolean "address_has_script", null: false
    t.binary "payment_cred"
    t.bigint "stake_address_id"
    t.decimal "value", null: false
    t.binary "data_hash"
    t.bigint "inline_datum_id"
    t.bigint "reference_script_id"
    t.index ["address"], name: "idx_tx_out_address", using: :hash
    t.index ["inline_datum_id"], name: "tx_out_inline_datum_id_idx"
    t.index ["payment_cred"], name: "idx_tx_out_payment_cred"
    t.index ["reference_script_id"], name: "tx_out_reference_script_id_idx"
    t.index ["stake_address_id"], name: "idx_tx_out_stake_address_id"
    t.index ["tx_id"], name: "idx_tx_out_tx_id"
    t.unique_constraint ["tx_id", "index"], name: "unique_txout"
  end

  create_table "withdrawal", force: :cascade do |t|
    t.bigint "addr_id", null: false
    t.decimal "amount", null: false
    t.bigint "redeemer_id"
    t.bigint "tx_id", null: false
    t.index ["addr_id", "tx_id"], name: "unique_withdrawal", unique: true
    t.index ["addr_id"], name: "idx_withdrawal_addr_id"
    t.index ["redeemer_id"], name: "idx_withdrawal_redeemer_id"
    t.index ["tx_id"], name: "idx_withdrawal_tx_id"
  end

end
