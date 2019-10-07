/*************/
/** Exhaust **/
/*************/

/**
 * Fan case sizes: used for all fan parts, including adapters, inlets
 * grills.
 */
fan_case = 120;
fan_screw_distance = 105;
fan_case_depth = 25;
fan_case_radius = 5;
fan_case_screw_radius = 2.5;
fan_case_socket_cap_radius = 5.6 / 2;
fan_case_screw_head_radius = 3;
fan_case_screw_head_angle = 90;

/**
 * Fan grill
 */
grill_screw_size = 3;
grill_screw_radius = grill_screw_size / 2;
grill_screw_inset = 2;
grill_radius = 114 / 2;
grill_fin_offset = 10;
grill_fin_thickness = 2;
grill_fin_degrees = 30;

rear_grill_thickness = 2;

front_grill_thickness = 2;
front_grill_fin_count = 6;
front_grill_fin_thickness = 2;

/**
 * Fan duct filter
 */
filter_thickness = 5;
filter_width = fan_screw_distance - fan_case_screw_radius * 3;
filter_offset = (fan_case - filter_width) / 2;

base_retainer_thickness = 2;
base_height = 30;
base_cut_offset = 10;
base_retainer_inset = 4;

/**
 * Fan to duct adapter
 */
adapter_thickness = 2;
adapter_duct_in = 3.8;
adapter_height = 25;
adapter_duct_height = 65;
flat_adapter_height = 14;
flat_adapter_duct_height = 50;
flat_adapter_screw_radius = 2;
flat_adapter_screw_head_radius = 4;

/**
 * Fan adapter filter caddy
 */
caddy_thickness = 2;
caddy_handle_width = 20;
caddy_handle_depth = 10;
caddy_handle_grip_count = 5;
caddy_handle_grip_depth = 1;
caddy_handle_grip_width = 1;
caddy_clip_height = 2;
caddy_clip_depth = 6;
caddy_clip_offset = 1;

/***************/
/** Enclosure **/
/***************/

/**
 * Enclosure foot
 */
foot_lower_radius = 15;
foot_upper_radius = 20;
foot_height = 18;
foot_inset_radius = 4;
foot_inset_depth = 3;
foot_screw_radius = 4;
foot_screw_inset = 6;
foot_screw_head_radius = 8;

/**
 * Power supply attachment
 */
power_supply_case_thickness = 3.0;
power_supply_screw_radius = 1.5;
power_supply_bushing_radius = 7.5;

power_supply_cable_pass_width = 18;
power_supply_cable_pass_height = 5;
power_supply_cable_pass_overhang = 5;
power_supply_cable_pass_overhang_depth = power_supply_case_thickness;
power_supply_cable_pass_depth = 3;
power_supply_cable_pass_thickness = 3;

/**
 * LED strip holder
 */
led_strip_cutout = 0.2;
led_strip_depth = 4;
led_strip_width = 8;
led_strip_screw_offset = 1.5;
led_strip_screw_radius = 1.5;
led_strip_screw_head = 2.8;
led_strip_nut_head = 3.25;
led_strip_nut_inset = 3;
led_strip_screw_inset = 3;

/**************/
/** Filament **/
/**************/

/**
 * Filament case passthrough
 */
through_base_width = 60;
through_base_height = 20;
through_base_depth = 5;
through_base_screw_offset = 10;
through_base_screw_radius = 1.5;
through_base_screw_head = 2.8;
through_base_nut_head = 3.25;
through_base_nut_inset = 3;
through_base_screw_inset = 3;
through_base_fitting_d = 5;
case_thickness = 1;
case_through_radius = 6;
filament_radius = 1;

inlet_length = 10;
inlet_outer_radius = 3;
inlet_inner_radius = 2;
inlet_angle = -20;


/**********/
/** Misc **/
/**********/

// tolerance is used all over the place to decide how closely parts fit
// together; adjust to the tolerances of your printer. 0.2 works fine for
// a Prusa i3 MK3.
tolerance = 0.2;
layer_height = 0.2;
