# 
# Synthesis run script generated by Vivado
# 

namespace eval rt {
    variable rc
}
set rt::rc [catch {
  uplevel #0 {
    set ::env(BUILTIN_SYNTH) true
    source $::env(HRT_TCL_PATH)/rtSynthPrep.tcl
    rt::HARTNDb_resetJobStats
    rt::HARTNDb_resetSystemStats
    rt::HARTNDb_startSystemStats
    rt::HARTNDb_startJobStats
    set rt::cmdEcho 0
    rt::set_parameter writeXmsg true
    rt::set_parameter enableParallelHelperSpawn true
    set ::env(RT_TMP) "Z:/CS-401-1-CompArch/Final_Project/MP_1_Compiler/Working_MP3/.Xil/Vivado-11620-LAB-SCI-214-18/realtime/tmp"
    if { [ info exists ::env(RT_TMP) ] } {
      file delete -force $::env(RT_TMP)
      file mkdir $::env(RT_TMP)
    }

    rt::delete_design

    set rt::partid xc7a100tcsg324-1

    set rt::multiChipSynthesisFlow false
    source $::env(SYNTH_COMMON)/common_vhdl.tcl
    set rt::defaultWorkLibName xil_defaultlib

    set rt::useElabCache false
    if {$rt::useElabCache == false} {
      rt::read_verilog -sv -include Z:/CS-401-1-CompArch/Final_Project/MP_1_Compiler/Working_MP3/mips.srcs/sources_1/imports/new C:/Xilinx/Vivado/2018.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv
      rt::read_vhdl -lib xil_defaultlib {
      Z:/CS-401-1-CompArch/Final_Project/MP_1_Compiler/Working_MP3/.Xil/Vivado-11620-LAB-SCI-214-18/realtime/dual_port_ram_stub.vhdl
      Z:/CS-401-1-CompArch/Final_Project/MP_1_Compiler/Working_MP3/mips.srcs/sources_1/imports/new/mips.vhd
      Z:/CS-401-1-CompArch/Final_Project/MP_1_Compiler/Working_MP3/mips.srcs/sources_1/imports/new/mips_mem_instructions.vhd
      Z:/CS-401-1-CompArch/Final_Project/MP_1_Compiler/Working_MP3/mips.srcs/sources_1/imports/new/mips_datapath.vhd
      Z:/CS-401-1-CompArch/Final_Project/MP_1_Compiler/Working_MP3/mips.srcs/sources_1/imports/new/mips_top.vhd
      Z:/CS-401-1-CompArch/Final_Project/MP_1_Compiler/Working_MP3/mips.srcs/sources_1/imports/new/mips_alu.vhd
      Z:/CS-401-1-CompArch/Final_Project/MP_1_Compiler/Working_MP3/mips.srcs/sources_1/imports/new/mips_adder.vhd
      Z:/CS-401-1-CompArch/Final_Project/MP_1_Compiler/Working_MP3/mips.srcs/sources_1/imports/new/mips_mem_data.vhd
      Z:/CS-401-1-CompArch/Final_Project/MP_1_Compiler/Working_MP3/mips.srcs/sources_1/imports/new/mips_decoder_alu.vhd
      Z:/CS-401-1-CompArch/Final_Project/MP_1_Compiler/Working_MP3/mips.srcs/sources_1/imports/new/mips_decoder_main.vhd
      Z:/CS-401-1-CompArch/Final_Project/MP_1_Compiler/Working_MP3/mips.srcs/sources_1/imports/new/computer_top.vhd
      Z:/CS-401-1-CompArch/Final_Project/MP_1_Compiler/Working_MP3/mips.srcs/sources_1/imports/new/mips_controller.vhd
      Z:/CS-401-1-CompArch/Final_Project/MP_1_Compiler/Working_MP3/mips.srcs/sources_1/imports/new/mips_sign_extender.vhd
      Z:/CS-401-1-CompArch/Final_Project/MP_1_Compiler/Working_MP3/mips.srcs/sources_1/imports/new/display_hex.vhd
      Z:/CS-401-1-CompArch/Final_Project/MP_1_Compiler/Working_MP3/mips.srcs/sources_1/imports/new/mips_flip_flop_register.vhd
      Z:/CS-401-1-CompArch/Final_Project/MP_1_Compiler/Working_MP3/mips.srcs/sources_1/imports/new/mips_multiplexer_2_input.vhd
      Z:/CS-401-1-CompArch/Final_Project/MP_1_Compiler/Working_MP3/mips.srcs/sources_1/new/generic_register.vhd
      Z:/CS-401-1-CompArch/Final_Project/MP_1_Compiler/Working_MP3/mips.srcs/sources_1/new/ListProc.vhd
      Z:/CS-401-1-CompArch/Final_Project/MP_1_Compiler/Working_MP3/mips.srcs/sources_1/new/alu_block.vhd
      Z:/CS-401-1-CompArch/Final_Project/MP_1_Compiler/Working_MP3/mips.srcs/sources_1/new/listAlu.vhd
      Z:/CS-401-1-CompArch/Final_Project/MP_1_Compiler/Working_MP3/mips.srcs/sources_1/new/list_register_file.vhd
      Z:/CS-401-1-CompArch/Final_Project/MP_1_Compiler/Working_MP3/mips.srcs/sources_1/new/mips_register_file.vhd
    }
      rt::read_vhdl -lib xpm C:/Xilinx/Vivado/2018.2/data/ip/xpm/xpm_VCOMP.vhd
      rt::filesetChecksum
    }
    rt::set_parameter usePostFindUniquification false
    set rt::top computer_top
    rt::set_parameter enableIncremental true
    set rt::reportTiming false
    rt::set_parameter elaborateOnly true
    rt::set_parameter elaborateRtl true
    rt::set_parameter eliminateRedundantBitOperator false
    rt::set_parameter elaborateRtlOnlyFlow true
    rt::set_parameter writeBlackboxInterface true
    rt::set_parameter merge_flipflops true
    rt::set_parameter srlDepthThreshold 3
    rt::set_parameter rstSrlDepthThreshold 4
# MODE: 
    rt::set_parameter webTalkPath {}
    rt::set_parameter enableSplitFlowPath "Z:/CS-401-1-CompArch/Final_Project/MP_1_Compiler/Working_MP3/.Xil/Vivado-11620-LAB-SCI-214-18/"
    set ok_to_delete_rt_tmp true 
    if { [rt::get_parameter parallelDebug] } { 
       set ok_to_delete_rt_tmp false 
    } 
    if {$rt::useElabCache == false} {
        set oldMIITMVal [rt::get_parameter maxInputIncreaseToMerge]; rt::set_parameter maxInputIncreaseToMerge 1000
        set oldCDPCRL [rt::get_parameter createDfgPartConstrRecurLimit]; rt::set_parameter createDfgPartConstrRecurLimit 1
        $rt::db readXRFFile
      rt::run_rtlelab -module $rt::top
        rt::set_parameter maxInputIncreaseToMerge $oldMIITMVal
        rt::set_parameter createDfgPartConstrRecurLimit $oldCDPCRL
    }

    set rt::flowresult [ source $::env(SYNTH_COMMON)/flow.tcl ]
    rt::HARTNDb_stopJobStats
    if { $rt::flowresult == 1 } { return -code error }


  set hsKey [rt::get_parameter helper_shm_key] 
  if { $hsKey != "" && [info exists ::env(BUILTIN_SYNTH)] && [rt::get_parameter enableParallelHelperSpawn] } { 
     $rt::db killSynthHelper $hsKey
  } 
  rt::set_parameter helper_shm_key "" 
    if { [ info exists ::env(RT_TMP) ] } {
      if { [info exists ok_to_delete_rt_tmp] && $ok_to_delete_rt_tmp } { 
        file delete -force $::env(RT_TMP)
      }
    }

    source $::env(HRT_TCL_PATH)/rtSynthCleanup.tcl
  } ; #end uplevel
} rt::result]

if { $rt::rc } {
  $rt::db resetHdlParse
  set hsKey [rt::get_parameter helper_shm_key] 
  if { $hsKey != "" && [info exists ::env(BUILTIN_SYNTH)] && [rt::get_parameter enableParallelHelperSpawn] } { 
     $rt::db killSynthHelper $hsKey
  } 
  source $::env(HRT_TCL_PATH)/rtSynthCleanup.tcl
  return -code "error" $rt::result
}