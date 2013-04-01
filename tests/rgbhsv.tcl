source lpd8806.tcl

 proc rgb_to_hsv {r g b} {
    set sorted [lsort -real [list $r $g $b]]
    set temp [lindex $sorted 0]
    set v [lindex $sorted 2]

    set value $v
    set bottom [expr {$v-$temp}]
    if {$bottom == 0} {
        set hue 0
        set saturation 0
        set value $v
    } else {
        if {$v == $r} {
            set top [expr {$g-$b}]
            if {$g >= $b} {
                set angle 0
            } else {
                set angle 360
            }
        } elseif {$v == $g} {
            set top [expr {$b-$r}]
            set angle 120
        } elseif {$v == $b} {
            set top [expr {$r-$g}]
            set angle 240
        }
        set hue [expr { round( 60 * ( double($top) / $bottom ) + $angle ) }]
    }

    if {$v == 0} {
        set saturation 0
    } else {
        set saturation [expr { round( 255 - 255 * ( double($temp) / $v ) ) }]
    }
    return [list $hue $saturation $value]
 }

 proc hsv_to_rgb {h s v} {
    set Hi [expr { int( double($h) / 60 ) % 6 }]
    set f [expr { double($h) / 60 - $Hi }]
    set s [expr { double($s)/255 }]
    set v [expr { double($v)/255 }]
    set p [expr { double($v) * (1 - $s) }]
    set q [expr { double($v) * (1 - $f * $s) }]
    set t [expr { double($v) * (1 - (1 - $f) * $s) }]
    switch -- $Hi {
        0 {
            set r $v
            set g $t
            set b $p
        }
        1 {
            set r $q
            set g $v
            set b $p
        }
        2 {
            set r $p
            set g $v
            set b $t
        }
        3 {
            set r $p
            set g $q
            set b $v
        }
        4 {
            set r $t
            set g $p
            set b $v
        }
        5 {
            set r $v
            set g $p
            set b $q
        }
        default {
            error "Wrong Hi value in hsvToRgb procedure! This should never happen!"
        }
    }
    set r [expr {round($r*255)}]
    set g [expr {round($g*255)}]
    set b [expr {round($b*255)}]
    return [list $r $g $b]
 }


 proc hls_to_rgb {h l s} {
    # h, l and s are floats between 0.0 and 1.0, ditto for r, g and b
    # h = 0   => red
    # h = 1/3 => green
    # h = 2/3 => blue

    set h6 [expr {($h-floor($h))*6}]
    set r [expr {  $h6 <= 3 ? 2-$h6
                            : $h6-4}]
    set g [expr {  $h6 <= 2 ? $h6
                            : $h6 <= 5 ? 4-$h6
                            : $h6-6}]
    set b [expr {  $h6 <= 1 ? -$h6
                            : $h6 <= 4 ? $h6-2
                            : 6-$h6}]
    set r [expr {$r < 0.0 ? 0.0 : $r > 1.0 ? 1.0 : double($r)}]
    set g [expr {$g < 0.0 ? 0.0 : $g > 1.0 ? 1.0 : double($g)}]
    set b [expr {$b < 0.0 ? 0.0 : $b > 1.0 ? 1.0 : double($b)}]

    set r [expr {(($r-1)*$s+1)*$l}]
    set g [expr {(($g-1)*$s+1)*$l}]
    set b [expr {(($b-1)*$s+1)*$l}]
    return [list $r $g $b]
 }

proc ramp {r1 g1 b1 r2 g2 b2 nSteps} {
    set steps [expr {double($nSteps)}]
    lassign [rgb_to_hsv $r1 $g1 $b1] h1 s1 v1
    lassign [rgb_to_hsv $r2 $g2 $b2] h2 s2 v2
    set hStep [expr {($h2 - $h1) / $steps}]
    set sStep [expr {($s2 - $s1) / $steps}]
    set vStep [expr {($v2 - $v1) / $steps}]

    for {set i 0; set h $h1; set s $s1; set v $v1} {$i <= $nSteps} {incr i; set h [expr {$h + $hStep}]; set s [expr {$s + $sStep}]; set v [expr {$v + $vStep}]} {
        lappend list [hsv_to_rgb $h $s $v]
    }
    return $list
}

proc practice_ramping {} {
    set r2 0
    set g2 0
    set b2 0

    while {true} {
        set r1 $r2
	set g1 $g2
	set b1 $b2

	set r 0
	set g 0
	set b 0

	set r2 [expr {round(rand() * 64)}]
	set g2 [expr {round(rand() * 64)}]
	set b2 [expr {round(rand() * 64)}]

	foreach rgb [ramp $r1 $g1 $b1 $r2 $g2 $b2 10] {
	    set or $r
	    set og $g
	    set ob $b
	    lassign $rgb r g b
	    left_right_fill $r $g $b $or $og $ob 20
	}


    }
}

if 0 {
 # Demo
 set r 100
 set g 200
 set b 150
 foreach {h s v} [rgb_to_hsv $r $g $b] {}
 puts "rgb: $r $g $b -> hsv: $h $s $v"
 puts "back to hsv: [hsvToRgb $h $s $v]"
 }
