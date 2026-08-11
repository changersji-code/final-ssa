-- SELECT
--   cc.CC_CALL_CENTER_ID AS call_center_id,
--   cc.CC_NAME AS call_center_name,
--   cc.CC_CLASS AS call_center_class,
--   cc.CC_EMPLOYEES AS employees,
--   cc.CC_SQ_FT AS sq_ft,
--   cc.CC_HOURS AS hours,
--   SUM(cs.CS_QUANTITY) AS sale_qty,
--   SUM(cr.CR_QUANTITY) AS return_qty,
--   SUM(cs.CS_NET_PROFIT_LOSS) - SUM(cr.CR_NET_PROFIT_LOSS) AS net_profit_loss
-- FROM
--   CALL Center cc
--   LEFT JOIN Catalog Sale cs ON cs.CS_CALL_CENTER_SK = cc.CC_CALL_CENTER_SK
--   LEFT JOIN Catalog RETURN cr ON cr.CR_CALL_CENTER_SK = cc.CC_CALL_CENTER_SK
-- GROUP BY
--   cc.CC_CALL_CENTER_ID,
--   cc.CC_NAME,
--   cc.CC_CLASS,
--   cc.CC_EMPLOYEES,
--   cc.CC_SQ_FT,
--   cc.CC_HOURS;


WITH sales AS (
  SELECT
    CS_CALL_CENTER_SK,
    SUM(CS_QUANTITY) AS sale_qty,
    SUM(CS_NET_PROFIT) AS sales_net_profit
  FROM CATALOG_SALES
  GROUP BY CS_CALL_CENTER_SK
),
returns AS (
  SELECT
    CR_CALL_CENTER_SK,
    SUM(CR_RETURN_QUANTITY) AS return_qty,
    SUM(CR_NET_LOSS) AS returns_net_loss
  FROM CATALOG_RETURNS
  GROUP BY CR_CALL_CENTER_SK
)
SELECT
  cc.CC_CALL_CENTER_ID AS call_center_id,
  cc.CC_NAME AS call_center_name,
  cc.CC_CLASS AS call_center_class,
  cc.CC_EMPLOYEES AS employees,
  cc.CC_SQ_FT AS sq_ft,
  cc.CC_HOURS AS hours,
  COALESCE(s.sale_qty, 0) AS sale_qty,
  COALESCE(r.return_qty, 0) AS return_qty,
  COALESCE(s.sales_net_profit, 0) - COALESCE(r.returns_net_loss, 0) AS net_profit_loss
FROM CALL_CENTER cc
LEFT JOIN sales s
  ON s.CS_CALL_CENTER_SK = cc.CC_CALL_CENTER_SK
LEFT JOIN returns r
  ON r.CR_CALL_CENTER_SK = cc.CC_CALL_CENTER_SK;