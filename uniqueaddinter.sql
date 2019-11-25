SELECT date_trunc ('week', tx.block_time) date, COUNT (DISTINCT owner)
    FROM ethereumnameservice."ENSRegistry_evt_NewOwner" r
      LEFT JOIN ethereum.transactions tx
       ON tx.hash = r.evt_tx_hash
    GROUP BY 1
