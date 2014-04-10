SET search_path = public, pg_catalog;

--
-- A view containing the deployed component information needed for the app
-- listing service.
--
CREATE VIEW deployed_component_listing AS
    SELECT row_number() OVER (ORDER BY apps.hid, tts.hid) AS id,
           apps.hid AS analysis_id,
           tts.hid AS execution_order,
           dc.hid AS deployed_component_hid,
           dc.id AS deployed_component_id,
           dc."name",
           dc.description,
           dc.location,
           tt."name" AS "type",
           dc.version,
           dc.attribution
    FROM apps
         JOIN transformation_task_steps tts ON apps.hid = tts.transformation_task_id
         JOIN transformation_steps ts ON tts.transformation_step_id = ts.id
         JOIN transformations tx ON ts.transformation_id = tx.id
         JOIN template t ON tx.template_id = t.id
         JOIN deployed_components dc ON t.component_id = dc.id
         JOIN tool_types tt ON dc.tool_type_id = tt.id;
