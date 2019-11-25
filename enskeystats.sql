SELECT COUNT (DISTINCT label) AS unique_domains_generated,
    COUNT (DISTINCT owner) AS unique_addresses_participated,
        SUM (tx.value/1e18) eth_spent,
        SUM (tx.value/1e18 * p.price) usd_spent
FROM ethereumnameservice."ENSRegistry_evt_NewOwner" r
  LEFT JOIN ethereum.transactions tx
    ON tx.hash = r.evt_tx_hash
  LEFT JOIN prices.usd_eth p
    ON p.minute = date_trunc('minute', tx.block_time)
