WITH ens1 AS (SELECT date_trunc ('week', tx.block_time) date, SUM (tx.value/1e18) eth_spent
                FROM ethereumnameservice."ENSRegistry_evt_NewOwner" r
                LEFT JOIN ethereum.transactions tx
                ON tx.hash = r.evt_tx_hash
                GROUP BY 1),
    price1 AS (SELECT date_trunc ('week', minute) date, AVG (price) avg_price_eth_usd
                    FROM prices."usd_eth"
                    GROUP BY 1)

SELECT ens1.date, (ens1.eth_spent * price1.avg_price_eth_usd) AS total_usd_spent,
        SUM (ens1.eth_spent * price1.avg_price_eth_usd) 
        OVER (ORDER BY ens1.date) AS cumulative_usd_spend
FROM ens1
JOIN price1
ON ens1.date = price1.date
