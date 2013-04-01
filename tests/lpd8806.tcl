
package require Tclx
package require tclspi

proc setup_spi {} {
    set spi [spi #auto /dev/spidev0.0]

    $spi read_mode 0
    $spi write_mode 0
    $spi write_bits_word 8
    $spi read_bits_word 8
    $spi write_maxspeed 2000000
    $spi read_maxspeed 2000000

    return $spi
}

set spi [setup_spi]

set nLEDs 160

proc rgb_to_chars {r g b} {
   return [format %c%c%c [expr $g | 0x80] [expr $r | 0x80] [expr $b | 0x80]]
}

proc n_latch_bytes {nLEDs} {
    return [expr {($nLEDs + 31) / 32}]
}

set latchBytes [replicate "\0" [n_latch_bytes $::nLEDs]]

proc make_fill_buffer {r g b} {
    set rgb [rgb_to_chars $r $g $b]

    return "[replicate $rgb $::nLEDs]$::latchBytes"
}

set blue [rgb_to_chars 0 0 127]
set red [rgb_to_chars 127 0 0]
set green [rgb_to_chars 0 127 0]
set black [rgb_to_chars 0 0 0]

set blueFill [make_fill_buffer 0 0 127]
set blackFill [make_fill_buffer 0 0 0]

proc setstrip {buffer} {
    $::spi transfer $buffer 1
    return ""
}

proc fill {r g b} {
    setstrip [make_fill_buffer $r $g $b]
}

proc blackout {} {
    setstrip $::blackFill
}

proc blueout {} {
    setstrip $::blueFill
}

proc split_fill {r1 g1 b1 nToFill r2 g2 b2} {
    return "[replicate [rgb_to_chars $r1 $g1 $b1] $nToFill][replicate [rgb_to_chars $r2 $g2 $b2] [expr {$::nLEDs - $nToFill}]]$::latchBytes"
}

proc reverse_split_fill {r1 g1 b1 nToFill r2 g2 b2} {
    return "[replicate [rgb_to_chars $r1 $g1 $b1] [expr {$::nLEDs - $nToFill}]][replicate [rgb_to_chars $r2 $g2 $b2] $nToFill]$::latchBytes"
}

proc out_in_fill {r1 g1 b1 nToFill r2 g2 b2} {
    return "[replicate [rgb_to_chars $r1 $g1 $b1] $nToFill][replicate [rgb_to_chars $r2 $g2 $b2] [expr {$::nLEDs - $nToFill * 2}]][replicate [rgb_to_chars $r1 $g1 $b1] $nToFill]$::latchBytes"
}

blueout

proc fast_test {} {
    for {set i 0} {$i < 1000} {incr i} {
	blueout
        puts $i
        blackout
    }
}

proc left_right_fill {r1 g1 b1 r2 g2 b2 delay} {
    for {set i 0} {$i <= $::nLEDs} {incr i} {
        setstrip [split_fill $r1 $g1 $b1 $i $r2 $g2 $b2]
	after $delay
    }
}

proc test2 {} {
    for {set i 0} {$i <= $::nLEDs} {incr i} {
        setstrip [split_fill 0 0 127 $i 0 0 0]
    }
}

proc test3 {} {
    for {set i 0} {$i <= $::nLEDs} {incr i} {
        setstrip [reverse_split_fill 0 0 127 $i 0 0 0]
    }
}

proc test4 {} {
    for {set i 0} {$i <= $::nLEDs / 2} {incr i} {
        setstrip [out_in_fill 0 0 127 $i 0 0 0]
	after 10
    }
}



#$spi delete

