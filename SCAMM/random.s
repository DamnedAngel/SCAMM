_rnd16::
	ld		de, #1 ; seed must not be 0
	ld		a, d
	rra
	ld		a, e
	rra
	xor		d
	ld		d, a
	ld		a, e
	rra
	ld		a, d
	rra
	xor		e
	ld		e, a
	ld		(#_xrnd + 1), a
	xor		d
	ld		d, a
	ld		(#_xrnd + 2), b
	ret