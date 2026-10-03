# Hex handles design history

The hex-handle project began from a set of previously printed driver handles with strongly sculpted bodies and later-applied surface texture. The CAD work here deliberately separates the **structural form** from that fine texture: the repository models the major ribs, collars, recesses, socket, adhesive features, and vent, while texture can be applied afterwards with a mesh modifier.

## Concept direction

The concept artwork established the target visual language:

- short, chunky workshop-tool proportions
- **five** broad longitudinal ribs
- deep planar recesses between ribs
- hard chamfers and angular transitions
- a strongly defined collar/waist region
- a segmented tail
- no dependence on fine texture for the silhouette

It also showed the functional idea of a 6.4 mm AF socket with epoxy-retention features and a tail vent.

## Discarded prototype 1 — smooth long body

The first CAD attempt captured the general waist-and-flare silhouette but was far too smooth and elongated. It lacked the concept's large structural ribs and read as a conventional rounded handle rather than the intended angular tool form.

It was not promoted into the repository version sequence.

## Discarded prototype 2 — eight-rib concept match

The second attempt added stronger fluting, collars, and a segmented tail, but still diverged from the reference in important ways:

- **eight ribs instead of five**
- rounded/filleted transitions instead of hard planar edges
- approximately 100 mm overall length
- a long section of printed handle extending beyond the metal shaft

That last point became a structural concern: with the handle printed along its axis, a long unreinforced tail could place high bending/shear load across layer lines.

It was also not promoted into the repository version sequence.

## v1 — 32 mm five-rib angular handle

The accepted design was rebuilt from scratch around the corrected constraints:

- **32 mm maximum overall length**
- a nominal **26 mm metal shaft** passing through most of the body
- exactly **5 hard-edged ribs**, 72° apart
- broad planar grip recesses
- polygonal shoulders and double collar
- only the tail tip rounded for comfort and local strength
- **6.4 mm AF** functional socket
- two outward **8.8 mm AF** epoxy reservoirs at approximately 1/3 and 2/3 depth
- continuous **2.4 mm** air/adhesive vent
- mouth-down print orientation
- a tapered internal roof instead of an abrupt horizontal bridge
- exterior slopes allowed to approach the stated **65°** printer capability rather than being artificially limited to 45°

The resulting shaft reinforces roughly **81% of the handle's length**, leaving only a short printed tail beyond the nominal metal extension.

The concept artwork and accepted V1 render are stored under `project/hex-handles/assets/`.
