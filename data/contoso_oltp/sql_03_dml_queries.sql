
-- insert new records
SET timezone = 'UTC';
INSERT INTO public.colors (color_name)
SELECT
    color_name || '__new__'
FROM public.colors
ORDER BY RANDOM()
LIMIT 1
;

-- updated existing records
BEGIN;
    SET timezone = 'UTC';
    -- Soft deleting for the color id = 10 (blue), the id = 11 is BLue
    UPDATE public.colors
    SET
        deleted_at = CURRENT_TIMESTAMP,
        updated_at = CURRENT_TIMESTAMP
    WHERE id = 10;

    -- Updating color id from `blue` to `Blue`
    UPDATE public.products
    SET
        color_id = 11,
        updated_at = CURRENT_TIMESTAMP
    WHERE color_id = 10;
COMMIT;

BEGIN;
    SET timezone = 'UTC';
    -- Soft deleting for the color id = 10 (blue), the id = 11 is BLue
    UPDATE public.brands
    SET
        deleted_at = CURRENT_TIMESTAMP,
        updated_at = CURRENT_TIMESTAMP
    WHERE id IN (1, 4, 8, 13);

    -- Updating color id from `blue` to `Blue`
    UPDATE public.products
    set
        brand_id = case
        	when brand_id = 1 then 11
        	when brand_id = 4 then 12
        	when brand_id = 8 then 9
        	when brand_id = 13 then 10
        end,
        updated_at = CURRENT_TIMESTAMP
    WHERE brand_id IN (1, 4, 8, 13);
COMMIT;
