
USING: kernel namespaces
       math
       math.constants
       math.functions
       math.order
       math.vectors
       math.trig
       math.ranges
       combinators arrays sequences random vars
       combinators.lib
       combinators.short-circuit
       accessors
       flatland ;

IN: boids

! !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

TUPLE: boid < <vel> ;

C: <boid> boid

! !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

VAR: boids
VAR: world-size
VAR: time-slice

! !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

VAR: cohesion-weight
VAR: alignment-weight
VAR: separation-weight

VAR: cohesion-view-angle
VAR: alignment-view-angle
VAR: separation-view-angle

VAR: cohesion-radius
VAR: alignment-radius
VAR: separation-radius

! !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

: init-variables ( -- )
  1.0 >cohesion-weight
  1.0 >alignment-weight
  1.0 >separation-weight

  75 >cohesion-radius
  50 >alignment-radius
  25 >separation-radius

  180 >cohesion-view-angle
  180 >alignment-view-angle
  180 >separation-view-angle

  10 >time-slice ;

! !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! random-boid and random-boids
! !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

: random-pos ( -- pos ) world-size> [ random ] map ;

: random-vel ( -- vel ) 2 [ drop -10 10 [a,b] random ] map ;

: random-boid ( -- boid ) random-pos random-vel <boid> ;

: random-boids ( n -- boids ) [ drop random-boid ] map ;

! !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

: constrain ( n a b -- n ) rot min max ;

: angle-between ( vec vec -- angle )
  2dup v. -rot norm swap norm * / -1 1 constrain acos rad>deg ;

! !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

: relative-position ( self other -- v ) swap [ pos>> ] bi@ v- ;

: relative-angle ( self other -- angle )
  over vel>> -rot relative-position angle-between ;

! !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

: vsum ( vector-of-vectors -- vec ) { 0 0 } [ v+ ] reduce ;

: vaverage ( seq-of-vectors -- seq ) [ vsum ] [ length ] bi v/n ;

: average-position ( boids -- pos ) [ pos>> ] map vaverage ;

: average-velocity ( boids -- vel ) [ vel>> ] map vaverage ;

! !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

: in-range? ( self other radius -- ? ) >r distance r> <= ;

: in-view? ( self other angle -- ? ) >r relative-angle r> 2 / <= ;

! !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

: normalize* ( u -- v ) { 0.001 0.001 } v+ normalize ;

! !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

! average_position(neighbors) - self_position

: within-cohesion-neighborhood? ( self other -- ? )
  { [ cohesion-radius> in-range? ]
    [ cohesion-view-angle> in-view? ]
    [ eq? not ] }
  2&& ;

: cohesion-neighborhood ( self -- boids )
  boids> [ within-cohesion-neighborhood? ] with filter ;

: cohesion-force ( self -- force )
  dup cohesion-neighborhood
  dup empty?
  [ 2drop { 0 0 } ]
  [ average-position swap pos>> v- normalize* cohesion-weight> v*n ]
  if ;

! !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

! self_position - average_position(neighbors)

: within-separation-neighborhood? ( self other -- ? )
  { [ separation-radius> in-range? ]
    [ separation-view-angle> in-view? ]
    [ eq? not ] }
  2&& ;

: separation-neighborhood ( self -- boids )
  boids> [ within-separation-neighborhood? ] with filter ;

: separation-force ( self -- force )
  dup separation-neighborhood
  dup empty?
  [ 2drop { 0 0 } ]
  [ average-position swap pos>> swap v- normalize* separation-weight> v*n ]
  if ;

! !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

! average_velocity(neighbors)

: within-alignment-neighborhood? ( self other -- ? )
  { [ alignment-radius> in-range? ]
    [ alignment-view-angle> in-view? ]
    [ eq? not ] }
  2&& ;

: alignment-neighborhood ( self -- boids )
  boids> [ within-alignment-neighborhood? ] with filter ;

: alignment-force ( self -- force )
  alignment-neighborhood
  dup empty?
  [ drop { 0 0 } ]
  [ average-velocity normalize* alignment-weight> v*n ]
  if ;

! !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

! F = m a
!
! We let m be equal to 1 so then this is simply: F = a

: acceleration ( boid -- acceleration )
  { separation-force alignment-force cohesion-force } map-exec-with vsum ;

! !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! iterate-boid
! !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

: world-width ( -- w ) world-size> first ;

: world-height ( -- w ) world-size> second ;

! !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

: below? ( n a b -- ? ) drop < ;

: above? ( n a b -- ? ) nip > ;

: wrap ( n a b -- n )
  {
    { [ 3dup below? ] [ 2nip     ] }
    { [ 3dup above? ] [ drop nip ] }
    { [ t           ] [ 2drop    ] }
  }
  cond ;

! !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

: wrap-x ( x -- x ) 0 world-width 1- wrap ;

: wrap-y ( y -- y ) 0 world-height 1- wrap ;

! !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

: new-pos ( boid -- pos ) [ pos>> ] [ vel>> time-slice> v*n ] bi v+ ;

: new-vel ( boid -- vel )
  [ vel>> ] [ acceleration time-slice> v*n ] bi v+ normalize* ;

: wrap-pos ( pos -- pos ) { [ wrap-x ] [ wrap-y ] } parallel-call ;

: iterate-boid ( self -- self ) [ new-pos wrap-pos ] [ new-vel ] bi <boid> ;

! !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

: iterate-boids ( -- ) boids> [ iterate-boid ] map >boids ;

! !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

: init-boids ( -- ) 100 random-boids >boids ;

: init-world-size ( -- ) { 100 100 } >world-size ;

! !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

: randomize ( -- ) boids> length random-boids >boids ;

: inc* ( variable -- ) dup  get 0.1 +  0 1 constrain  swap set ;

: dec* ( variable -- ) dup  get 0.1 -  0 1 constrain  swap set ;

