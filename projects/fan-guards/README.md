# Fan guards

Printed and experimental fan grilles and airflow guards.

## SweepHex XL family

All SweepHex XL models are flat 6 mm guards with large anticlockwise swept-hex apertures and support-free broad-face printing. The 140 mm original has physical print evidence; the smaller variants are generated and geometrically validated but not yet physically tested.

| Model | Size | Mount pitch | Airflow apertures | Mid-plane open area | Physical status |
| --- | ---: | ---: | ---: | ---: | --- |
| [SweepHex 140 XL](sweephex-140-xl/) | 140 mm | 124.5 mm | 43 | 58.7% | **Printed and installed** — [front](sweephex-140-xl/assets/printed-front.jpg) · [oblique](sweephex-140-xl/assets/printed-oblique.jpg) |
| [SweepHex 120 XL](sweephex-120-xl/) | 120 mm | 105 mm | 33 | 57.2% | Generated / unprinted |
| [SweepHex 92 XL](sweephex-92-xl/) | 92 mm | 82.5 mm | 19 | 55.9% | Generated / unprinted |
| [SweepHex 80 XL](sweephex-80-xl/) | 80 mm | 71.5 mm | 17 | 54.2% | Generated / unprinted |
| [SweepHex 60 XL](sweephex-60-xl/) | 60 mm | 50 mm | 7 | 52.1% | Generated / unprinted |

The compact variants share [one parametric generator](sweephex_family_generator.py) and [one static validator](validate_sweephex_variants.py). Their mounting pitches follow the nominal square-fan dimensions used by current Noctua 120/92/80/60 mm models.

Open apertures are **not a substitute for a fingertip-safe fan guard**. Swirl direction is a design choice; no turbulence, airflow or acoustic improvement is established without measurements.
