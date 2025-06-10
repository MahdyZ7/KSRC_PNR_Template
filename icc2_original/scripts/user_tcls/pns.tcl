






create_pg_mesh_pattern pg_vdd_vss_mesh1 \
-parameters {w p t s } \
-layers {{{vertical_layer: C5} {width: @w} {spacing: @s} \
{pitch: @p} {trim: @t}}} -via_rule {{intersection: adjacent}{via_master: default}}




set_pg_strategy s_mesh1 \
-pattern {{pattern: pg_vdd_vss_mesh1} {nets: { VDD VSS VDD VSS }} \
{parameters: 0.68 12 false 2.5 }} \
-core  -extension {{stop: design_boundary_and_generate_pin}}


create_pg_std_cell_conn_pattern \
std_cell_rail \
-layers {M1}

set_pg_strategy rail_strat -core \
-pattern {{name: std_cell_rail} {nets: VDD VSS} }

set_pg_strategy_via_rule r2 \
-via_rule { \
             {{{strategies: s_mesh1}{layers: C5}}{{strategies: rail_strat}{layers: M1}} \
                           {via_master: VIA01_20_20_20_20_XX_V1 VIA02_BAR_H_20_20_20_20_AY VIA03_BAR_H_18_18_18_18_A1 VIA04_BAR_H_0_36_0_36_A2 VIA05_BAR_H_18_18_18_18_A3 VIA06_BAR_H_18_18_18_18_A4}} \
                           {{intersection: undefined}{via_master: NIL}} \
          }



compile_pg -via_rule r2

