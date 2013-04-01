
source lpd8806.tcl

package require tclgd

proc loadpic {file} {
    set fp [open $file]
    fconfigure $fp -translation binary
    set handle [GD create_from_jpeg #auto $fp]
    close $fp
    return $handle
}

set pic [loadpic DSC_0033.JPG]

proc make_photo_lines {} {
    set height [$::pic height]
    set width [$::pic width]

    set wStep [expr $width / $::nLEDs]

    for {set i 0} {$i < $height} {incr i} {
        puts $i
	lappend lines [make_pic_line_fill $::pic $i $wStep $width]
    }
    return $lines
}

proc make_pic_line_fill {pic h wStep width} {
    for {set i 0; set w 0} {$i < $::nLEDs} {incr i;incr w $wStep} {
	lassign [$pic pixelrgb $w $h] r g b
	append fill [rgb_to_chars [expr {$r /3}] [expr {$g / 3}] [expr {$b / 3}]]
    }
    append fill $::latchBytes
    return $fill
}

set photofill [make_photo_lines]

proc test5 {} {
    foreach line $::photofill {
        setstrip $line
	after 10
    }
}
