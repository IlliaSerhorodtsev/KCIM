breed [rabbits rabbit]
rabbits-own [energy gender sick-ticks is-sick?]

to setup
  clear-all
  grow-grass-and-weeds
  set-default-shape rabbits "rabbit"
  create-rabbits number [
    setxy random-xcor random-ycor
    set energy random 10  ; start with a random amount of energy
    set gender one-of ["male" "female"]  ; assign random gender
    if gender = "male" [ set color blue ]
    if gender = "female" [ set color pink ]
    set is-sick? false
    set sick-ticks 0
  ]
  reset-ticks
end

to go
  if not any? rabbits [ stop ]
  grow-grass-and-weeds
  ask rabbits [
    if is-sick? [
      stay-sick
    ] 
    if not is-sick? [
      move 
      eat-grass
      eat-weeds
      reproduce
      death
    ]
  ]
  tick
end

to grow-grass-and-weeds
  ask patches [
    if pcolor = black [
      if random-float 1000 < grass-grow-rate [
        set pcolor green
      ]
    ]
    if pcolor = black or pcolor = green [
      if random-float 1000 < weeds-grow-rate [
        set pcolor violet
      ]
    ]
  ]
end


to move  ;; rabbit procedure
  rt random 50
  lt random 50
  fd 1
  set energy energy - 0.5
end

to eat-grass  ;; rabbit procedure
  if pcolor = green [
    set pcolor black
    set energy energy + grass-energy
  ]
end

to eat-weeds  ;; rabbit procedure
  if pcolor = violet [
    set pcolor black
    if random-float 100 < poison-chance [
      set is-sick? true
      set color red  ; change color to indicate sickness
      set sick-ticks 3  ; remain sick for 3 ticks
    ] 
     if not is-sick? [
      set energy energy + weed-energy
    ]
  ]
end

to reproduce  ;; rabbit procedure
  if energy > birth-threshold and not is-sick? [
    let partner one-of rabbits-here with [gender != [gender] of myself and energy > birth-threshold and not is-sick?]
    if partner != nobody and random-float 100 < 50 [
      set energy energy / 2
      ask partner [ set energy energy / 2 ]
      hatch 1 [
        set energy energy / 2
        set gender one-of ["male" "female"]
        if gender = "male" [ set color blue ]
        if gender = "female" [ set color pink ]
        fd 1
      ]
    ]
  ]
end

to stay-sick
  set sick-ticks sick-ticks - 1
  if sick-ticks <= 0 [
    set is-sick? false
     if gender = "male" [ set color blue ]
     if gender = "female" [ set color pink ]
    set energy energy - 5
  ]
end

to death  ;; rabbit procedure
  if energy < 0 [ die ]
end
