WITH ens1 AS (SELECT date_trunc ('week', tx.block_time) date, SUM (tx.value/1e18) eth_spent
                FROM ethereumnameservice."ENSRegistry_evt_NewOwner" r
                LEFT JOIN ethereum.transactions tx
                ON tx.hash = r.evt_tx_hash
                GROUP BY 1),
    ens2 AS (SELECT date_trunc ('week', tx.block_time) date, SUM (tx.value/1e18) eth_spent
                FROM ethereumnameservice."ENSRegistry_evt_Transfer" r
                LEFT JOIN ethereum.transactions tx
                ON tx.hash = r.evt_tx_hash
                GROUP BY 1),
    price1 AS (SELECT date_trunc ('week', minute) date, AVG (price) avg_price_eth_usd
                    FROM prices."usd_eth"
                    GROUP BY 1),
    cumul AS (SELECT ens1.date,
                SUM (ens1.eth_spent * price1.avg_price_eth_usd) OVER (ORDER BY ens1.date) AS primary_spend,
                SUM (ens2.eth_spent * price1.avg_price_eth_usd) OVER (ORDER BY ens2.date) AS secondary_spend
                FROM ens1
                JOIN price1
                  ON ens1.date = price1.date
                JOIN ens2
                  ON ens2.date = price1.date)

SELECT cumul.date, 
        COALESCE (cumul.primary_spend / NULLIF ((cumul.primary_spend + cumul.secondary_spend), 0), 0) AS primary_mkt_spend_pct,
        COALESCE (cumul.secondary_spend / NULLIF ((cumul.primary_spend + cumul.secondary_spend), 0), 0) AS secondary_mkt_spend_pct
FROM cumul
WHERE cumul.date > '20170517'
