SELECT date_trunc('week', block_time), COUNT(DISTINCT label) names_created, 
        SUM (COUNT(DISTINCT label)) OVER (ORDER BY date_trunc('week', block_time)) AS cumulative_names_created
FROM ethereumnameservice."ENSRegistry_evt_NewOwner" r 
  LEFT JOIN ethereum.transactions tx ON tx.hash = r.evt_tx_hash
GROUP BY 1
