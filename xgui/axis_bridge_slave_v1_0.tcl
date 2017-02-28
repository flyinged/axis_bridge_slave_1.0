# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  #Adding Page
  set User_Parameters [ipgui::add_page $IPINST -name "User Parameters"]
  ipgui::add_param $IPINST -name "Component_Name" -parent ${User_Parameters}
  ipgui::add_param $IPINST -name "POSTED_WRITES" -parent ${User_Parameters} -layout horizontal
  ipgui::add_param $IPINST -name "IGNORE_MGT_BACKPRESSURE" -parent ${User_Parameters} -layout horizontal
  #Adding Group
  set RX_Address_Mask [ipgui::add_group $IPINST -name "RX Address Mask" -parent ${User_Parameters}]
  ipgui::add_param $IPINST -name "RX_ADDR_MASK" -parent ${RX_Address_Mask}

  #Adding Group
  set K-Characters [ipgui::add_group $IPINST -name "K-Characters" -parent ${User_Parameters}]
  set_property tooltip {K-Characters} ${K-Characters}
  ipgui::add_param $IPINST -name "K_INT" -parent ${K-Characters}
  ipgui::add_param $IPINST -name "K_SOF" -parent ${K-Characters}
  ipgui::add_param $IPINST -name "K_EOF" -parent ${K-Characters}


  #Adding Page
  set AXI [ipgui::add_page $IPINST -name "AXI" -display_name {AXI (Locked)}]
  ipgui::add_param $IPINST -name "C_S00_AXI_BASEADDR" -parent ${AXI}
  ipgui::add_param $IPINST -name "C_S00_AXI_HIGHADDR" -parent ${AXI}

  set TIMEOUT_CYCLES [ipgui::add_param $IPINST -name "TIMEOUT_CYCLES"]
  set_property tooltip {Timeout in AXI_CLK cycles. Set to 0 to disable.} ${TIMEOUT_CYCLES}

}

proc update_PARAM_VALUE.C_S00_AXI_ADDR_WIDTH { PARAM_VALUE.C_S00_AXI_ADDR_WIDTH } {
	# Procedure called to update C_S00_AXI_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_ADDR_WIDTH { PARAM_VALUE.C_S00_AXI_ADDR_WIDTH } {
	# Procedure called to validate C_S00_AXI_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_ARUSER_WIDTH { PARAM_VALUE.C_S00_AXI_ARUSER_WIDTH } {
	# Procedure called to update C_S00_AXI_ARUSER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_ARUSER_WIDTH { PARAM_VALUE.C_S00_AXI_ARUSER_WIDTH } {
	# Procedure called to validate C_S00_AXI_ARUSER_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_AWUSER_WIDTH { PARAM_VALUE.C_S00_AXI_AWUSER_WIDTH } {
	# Procedure called to update C_S00_AXI_AWUSER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_AWUSER_WIDTH { PARAM_VALUE.C_S00_AXI_AWUSER_WIDTH } {
	# Procedure called to validate C_S00_AXI_AWUSER_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_BUSER_WIDTH { PARAM_VALUE.C_S00_AXI_BUSER_WIDTH } {
	# Procedure called to update C_S00_AXI_BUSER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_BUSER_WIDTH { PARAM_VALUE.C_S00_AXI_BUSER_WIDTH } {
	# Procedure called to validate C_S00_AXI_BUSER_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_DATA_WIDTH { PARAM_VALUE.C_S00_AXI_DATA_WIDTH } {
	# Procedure called to update C_S00_AXI_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_DATA_WIDTH { PARAM_VALUE.C_S00_AXI_DATA_WIDTH } {
	# Procedure called to validate C_S00_AXI_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_ID_WIDTH { PARAM_VALUE.C_S00_AXI_ID_WIDTH } {
	# Procedure called to update C_S00_AXI_ID_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_ID_WIDTH { PARAM_VALUE.C_S00_AXI_ID_WIDTH } {
	# Procedure called to validate C_S00_AXI_ID_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_RUSER_WIDTH { PARAM_VALUE.C_S00_AXI_RUSER_WIDTH } {
	# Procedure called to update C_S00_AXI_RUSER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_RUSER_WIDTH { PARAM_VALUE.C_S00_AXI_RUSER_WIDTH } {
	# Procedure called to validate C_S00_AXI_RUSER_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_WUSER_WIDTH { PARAM_VALUE.C_S00_AXI_WUSER_WIDTH } {
	# Procedure called to update C_S00_AXI_WUSER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_WUSER_WIDTH { PARAM_VALUE.C_S00_AXI_WUSER_WIDTH } {
	# Procedure called to validate C_S00_AXI_WUSER_WIDTH
	return true
}

proc update_PARAM_VALUE.IGNORE_MGT_BACKPRESSURE { PARAM_VALUE.IGNORE_MGT_BACKPRESSURE } {
	# Procedure called to update IGNORE_MGT_BACKPRESSURE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.IGNORE_MGT_BACKPRESSURE { PARAM_VALUE.IGNORE_MGT_BACKPRESSURE } {
	# Procedure called to validate IGNORE_MGT_BACKPRESSURE
	return true
}

proc update_PARAM_VALUE.POSTED_WRITES { PARAM_VALUE.POSTED_WRITES } {
	# Procedure called to update POSTED_WRITES when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.POSTED_WRITES { PARAM_VALUE.POSTED_WRITES } {
	# Procedure called to validate POSTED_WRITES
	return true
}

proc update_PARAM_VALUE.RX_ADDR_MASK { PARAM_VALUE.RX_ADDR_MASK } {
	# Procedure called to update RX_ADDR_MASK when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.RX_ADDR_MASK { PARAM_VALUE.RX_ADDR_MASK } {
	# Procedure called to validate RX_ADDR_MASK
	return true
}

proc update_PARAM_VALUE.TIMEOUT_CYCLES { PARAM_VALUE.TIMEOUT_CYCLES } {
	# Procedure called to update TIMEOUT_CYCLES when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.TIMEOUT_CYCLES { PARAM_VALUE.TIMEOUT_CYCLES } {
	# Procedure called to validate TIMEOUT_CYCLES
	return true
}

proc update_PARAM_VALUE.K_SOF { PARAM_VALUE.K_SOF } {
	# Procedure called to update K_SOF when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.K_SOF { PARAM_VALUE.K_SOF } {
	# Procedure called to validate K_SOF
	return true
}

proc update_PARAM_VALUE.K_EOF { PARAM_VALUE.K_EOF } {
	# Procedure called to update K_EOF when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.K_EOF { PARAM_VALUE.K_EOF } {
	# Procedure called to validate K_EOF
	return true
}

proc update_PARAM_VALUE.K_INT { PARAM_VALUE.K_INT } {
	# Procedure called to update K_INT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.K_INT { PARAM_VALUE.K_INT } {
	# Procedure called to validate K_INT
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_BASEADDR { PARAM_VALUE.C_S00_AXI_BASEADDR } {
	# Procedure called to update C_S00_AXI_BASEADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_BASEADDR { PARAM_VALUE.C_S00_AXI_BASEADDR } {
	# Procedure called to validate C_S00_AXI_BASEADDR
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_HIGHADDR { PARAM_VALUE.C_S00_AXI_HIGHADDR } {
	# Procedure called to update C_S00_AXI_HIGHADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_HIGHADDR { PARAM_VALUE.C_S00_AXI_HIGHADDR } {
	# Procedure called to validate C_S00_AXI_HIGHADDR
	return true
}


proc update_MODELPARAM_VALUE.K_SOF { MODELPARAM_VALUE.K_SOF PARAM_VALUE.K_SOF } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.K_SOF}] ${MODELPARAM_VALUE.K_SOF}
}

proc update_MODELPARAM_VALUE.K_EOF { MODELPARAM_VALUE.K_EOF PARAM_VALUE.K_EOF } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.K_EOF}] ${MODELPARAM_VALUE.K_EOF}
}

proc update_MODELPARAM_VALUE.K_INT { MODELPARAM_VALUE.K_INT PARAM_VALUE.K_INT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.K_INT}] ${MODELPARAM_VALUE.K_INT}
}

proc update_MODELPARAM_VALUE.C_S00_AXI_ID_WIDTH { MODELPARAM_VALUE.C_S00_AXI_ID_WIDTH PARAM_VALUE.C_S00_AXI_ID_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_AXI_ID_WIDTH}] ${MODELPARAM_VALUE.C_S00_AXI_ID_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S00_AXI_DATA_WIDTH { MODELPARAM_VALUE.C_S00_AXI_DATA_WIDTH PARAM_VALUE.C_S00_AXI_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_AXI_DATA_WIDTH}] ${MODELPARAM_VALUE.C_S00_AXI_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S00_AXI_ADDR_WIDTH { MODELPARAM_VALUE.C_S00_AXI_ADDR_WIDTH PARAM_VALUE.C_S00_AXI_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_AXI_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_S00_AXI_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S00_AXI_ARUSER_WIDTH { MODELPARAM_VALUE.C_S00_AXI_ARUSER_WIDTH PARAM_VALUE.C_S00_AXI_ARUSER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_AXI_ARUSER_WIDTH}] ${MODELPARAM_VALUE.C_S00_AXI_ARUSER_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S00_AXI_RUSER_WIDTH { MODELPARAM_VALUE.C_S00_AXI_RUSER_WIDTH PARAM_VALUE.C_S00_AXI_RUSER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_AXI_RUSER_WIDTH}] ${MODELPARAM_VALUE.C_S00_AXI_RUSER_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S00_AXI_AWUSER_WIDTH { MODELPARAM_VALUE.C_S00_AXI_AWUSER_WIDTH PARAM_VALUE.C_S00_AXI_AWUSER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_AXI_AWUSER_WIDTH}] ${MODELPARAM_VALUE.C_S00_AXI_AWUSER_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S00_AXI_WUSER_WIDTH { MODELPARAM_VALUE.C_S00_AXI_WUSER_WIDTH PARAM_VALUE.C_S00_AXI_WUSER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_AXI_WUSER_WIDTH}] ${MODELPARAM_VALUE.C_S00_AXI_WUSER_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S00_AXI_BUSER_WIDTH { MODELPARAM_VALUE.C_S00_AXI_BUSER_WIDTH PARAM_VALUE.C_S00_AXI_BUSER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_AXI_BUSER_WIDTH}] ${MODELPARAM_VALUE.C_S00_AXI_BUSER_WIDTH}
}

proc update_MODELPARAM_VALUE.RX_ADDR_MASK { MODELPARAM_VALUE.RX_ADDR_MASK PARAM_VALUE.RX_ADDR_MASK } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RX_ADDR_MASK}] ${MODELPARAM_VALUE.RX_ADDR_MASK}
}

proc update_MODELPARAM_VALUE.POSTED_WRITES { MODELPARAM_VALUE.POSTED_WRITES PARAM_VALUE.POSTED_WRITES } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.POSTED_WRITES}] ${MODELPARAM_VALUE.POSTED_WRITES}
}

proc update_MODELPARAM_VALUE.IGNORE_MGT_BACKPRESSURE { MODELPARAM_VALUE.IGNORE_MGT_BACKPRESSURE PARAM_VALUE.IGNORE_MGT_BACKPRESSURE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IGNORE_MGT_BACKPRESSURE}] ${MODELPARAM_VALUE.IGNORE_MGT_BACKPRESSURE}
}

proc update_MODELPARAM_VALUE.TIMEOUT_CYCLES { MODELPARAM_VALUE.TIMEOUT_CYCLES PARAM_VALUE.TIMEOUT_CYCLES } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.TIMEOUT_CYCLES}] ${MODELPARAM_VALUE.TIMEOUT_CYCLES}
}

