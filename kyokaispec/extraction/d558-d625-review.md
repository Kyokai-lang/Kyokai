# D558-D625 Clause Extraction Review

This file is generated from `kyokaispec/extraction/d558-d625.toml` by
`toolchain/spec/check_clause_extraction.py`. Do not edit it manually.

The checker verifies inventory closure, accepted-source identity, destination
existence, exact-name tripwires, supersession edges, and trace-row coverage.
It does not replace semantic review or claim implementation, conformance,
admission, operational readiness, or proof.

Review class: `lead-maintainer-directed-extraction`.
Reviewer: Rikona Kurasaki / Mjoyufull.
Review date: `2026-07-16`.
Accepted cutoff: `D625; D626 withdrawn by D596a`.
Reviewed revision: `working tree accepted through D625`.

The lead maintainer accepted D558-D625 and explicitly directed clause-evidence closure. The checker performs the mechanical completeness audit; it does not invent an independent reviewer or semantic vote.

## Checked Projections

The registry also checks the public traceability, maturity, and Gate-A
views named below. A stale projection fails the same check as a stale
generated review.

| Kind | Path | Checked terms |
| --- | --- | ---: |
| `traceability` | `kyokaispec/src/project/02-decision-traceability.md` | 3 |
| `maturity` | `Kyokaishape.md` | 5 |
| `maturity` | `kyokaidecided.md` | 4 |
| `gate` | `phase.md` | 3 |

## Decision Summary

| Decision | State | Live clauses | Source lines | Source SHA-256 | Proof impact |
| --- | --- | ---: | --- | --- | --- |
| `D558` | `complete` | 5 | `8218-8225` | `559e08417b2b94d92d185fccf052c6cda81dc9f85d5b2302cd965c3710dff205` | `MODEL_AFFECTING` |
| `D559` | `complete` | 7 | `8226-8233` | `9fc24347fc4916dca0e9ff9baa2ce0a988336340306051acf890f25a0bf39f24` | `MODEL_AFFECTING` |
| `D560` | `complete` | 5 | `8234-8241` | `c6fb5be86504c4643acc9bd5e2c68ac6628014d2c730d0423c09abae425eee92` | `MODEL_AFFECTING` |
| `D561` | `complete` | 6 | `8242-8249` | `406f298bb7394cf4289baf1b8147caab7173d030b3a26fb6fb6bc31e397070d1` | `MODEL_AFFECTING` |
| `D562` | `complete` | 9 | `8250-8255` | `ee306a63a899b5bead79b204a83c8f1365626a6b390dae4085aadebc50028215` | `NO_SEMANTIC_IMPACT` |
| `D562a` | `complete` | 4 | `8256-8263` | `8dd2d6c96fe5ea16c0e98a70849ad3bf7b9c034f41c143405b99837a6faf6946` | `NO_SEMANTIC_IMPACT` |
| `D563` | `complete` | 7 | `8264-8269` | `9e4ce8ba1dc413fc806c9a7928da18a397d5da77ec21972b5a430fbf2dbed2c8` | `MODEL_AFFECTING` |
| `D564` | `complete` | 8 | `8270-8277` | `9ede8e7305ec5050d20a86a19c26aeb38a7a4d9152aecddae9cb6c522aac9dea` | `MODEL_AFFECTING` |
| `D565` | `complete` | 5 | `8278-8287` | `dce53dad036dadf4932347cc75ab7553a6095f8f5bb4ab930eff91d06e6c3417` | `MODEL_AFFECTING` |
| `D566` | `complete` | 8 | `8288-8293` | `d580b0aa4db5279c98fac063460879bb911af2835b80ba958b5ece43e8d1aef1` | `MODEL_AFFECTING` |
| `D567` | `complete` | 5 | `8294-8301` | `d5312668f83aee40c51d989810d334161b6b9fce15543942380bce0ad202d640` | `MODEL_AFFECTING` |
| `D568` | `complete` | 5 | `8302-8307` | `c9afd42b09e73bdcaf322e7a464633e9b65cdabe4e162822d9e9a9d09abfc5d2` | `MODEL_AFFECTING` |
| `D569` | `complete` | 5 | `8308-8313` | `189d64e23bfa2a441015a03eec54e9ab44e2e66d37559b26e630ee42fead4658` | `MODEL_AFFECTING` |
| `D569a` | `complete` | 9 | `8314-8319` | `ea4ec89483e647b0e4e423a69326cfb75549d4c3b6c7b1daa9864af369b01ae0` | `MAPPING_ONLY` |
| `D569b` | `complete` | 9 | `8320-8325` | `ded59c7170edcc82150a6b3768949a9bfbba7c80f254fa904f819b1589bc4a20` | `MAPPING_ONLY` |
| `D569c` | `complete` | 9 | `8326-8335` | `40f679b968a076540e6df2e6cca1f8632d0c4e7a3631056b41397002121f5362` | `MAPPING_ONLY` |
| `D570` | `complete` | 9 | `8336-8347` | `5726edacfa3c5c5067f2c96d99480505304ee3c9f19241c22eebcd4d354bcdbd` | `MAPPING_ONLY` |
| `D571` | `complete` | 6 | `8454-8486` | `df15c459d7b6b3a13e652f90c2842e4924e8631cbd2f1c9b81b503d940d6d44e` | `MODEL_AFFECTING` |
| `D572` | `complete` | 9 | `8487-8511` | `5ad5a44d252d0285122c8aebbb8738bcd534d17be209f9b8f3486c070c953a49` | `MAPPING_ONLY` |
| `D573` | `complete` | 9 | `8512-8537` | `99e976f0205f39329a0345160ef6e33a4e731464772413dda116dfd3c2edd97d` | `MAPPING_ONLY` |
| `D573a` | `complete` | 8 | `8538-8582` | `3125bc82fd8639dc8dfc638c01589a91b2dcab91c64066c9f11fa533709967bd` | `MODEL_AFFECTING` |
| `D574` | `complete` | 9 | `8583-8604` | `b3a9c7f1beb31c93d353daf0852be7d4c3937067c49c5e706aa6236b65cd4773` | `MAPPING_ONLY` |
| `D575` | `complete` | 9 | `8605-8626` | `cf54ca306200a53c9646b338b43d418bed299268ef3b4651e2435e2fa06d0732` | `MAPPING_ONLY` |
| `D576` | `complete` | 9 | `8627-8650` | `87537efadfec315d3489c2e881d7e2fa87ff91d6229d56857559be704859952f` | `MAPPING_ONLY` |
| `D577` | `complete` | 4 | `8651-8675` | `6b24549523ff3ef16b4f5c20dc959bce778b24f453f5cf318055ebb851f9a9fc` | `NO_SEMANTIC_IMPACT` |
| `D578` | `complete` | 4 | `8676-8693` | `b2f17b25d73a820dbd6de1f233101d2378193c804f9162cdca2aae289fd71e2b` | `NO_SEMANTIC_IMPACT` |
| `D579` | `complete` | 8 | `8694-8718` | `0683b7801746d32f8cc5b421ed5921bb542a23c477589497b7ea905ba3de6e5f` | `NO_SEMANTIC_IMPACT` |
| `D580` | `complete` | 4 | `8719-8748` | `baa463bbb6d1358a03c263f3671bcc338d4e200e7efb38bd8fb50f0926147031` | `MAPPING_ONLY` |
| `D581` | `complete` | 4 | `8749-8767` | `aff99bb46ee4d792840065b4cdfa91ac471d432ab529e65fde6d3d6d52c86b5d` | `NO_SEMANTIC_IMPACT` |
| `D582` | `complete` | 4 | `8768-8809` | `6ae9fc363f68400dbacfc1aff1945ba8e799b97cd1ef05e341ab249f391e4617` | `NO_SEMANTIC_IMPACT` |
| `D583` | `complete` | 4 | `8810-8850` | `62ba9264b905b0b46a34472b62fc94716db9083aaeddbf14f5346574e4c2179e` | `NO_SEMANTIC_IMPACT` |
| `D584` | `complete` | 9 | `8859-8876` | `d2741c3c16d8e890aeb14c19f26d48b4b3e3eac19a019a27c1f931afda59dd88` | `MAPPING_ONLY` |
| `D585` | `complete` | 5 | `8877-8895` | `32a4396c2414190e18b04d8eea8ccfcc226d6f82a6d9ea1601558251de225a43` | `MODEL_AFFECTING` |
| `D586` | `complete` | 9 | `8896-8910` | `7e1813990c54b58e147152b7232c5bb6318f9ef6a6d5df61d6874cddbfa7499f` | `MAPPING_ONLY` |
| `D587` | `complete` | 9 | `8911-8926` | `fb4b49f8dedd278d2e0b752a76d91fd3a1db138080d4e347811e1426b5cf67c4` | `MAPPING_ONLY` |
| `D588` | `complete` | 9 | `8927-8942` | `17490a8e5f9b31ccf8a0ee116871450142d522c554b24cb97cf2033f7a954f96` | `MAPPING_ONLY` |
| `D589` | `complete` | 8 | `8943-8958` | `da678d1ff6c073b1e8c8454c81fd47840925159017f4b6a0c66e8334ac6b4415` | `MAPPING_ONLY` |
| `D590` | `complete` | 8 | `8959-8978` | `92174dfb76a252b94ba34bae12bbffda725b0e9d3e82418ac96cb77bb373c5be` | `MAPPING_ONLY` |
| `D591` | `complete` | 9 | `8979-8995` | `192c34576a4aa2fa6e0f77aa0f1c79bb4cf44c150c757d673c422c690b465de8` | `MAPPING_ONLY` |
| `D592` | `complete` | 9 | `8996-9013` | `1a71add2c059a7644790c1dbb31b5adc438867eea1f61d80d7391f782ac5b28e` | `MAPPING_ONLY` |
| `D592a` | `complete` | 4 | `9014-9053` | `2c7139bead566ec42ef4c3c8256ebb61e268c0c843a7cecc36a3b28c7749dbc9` | `NO_SEMANTIC_IMPACT` |
| `D593` | `complete` | 9 | `9054-9080` | `fbbce463e05c62b6ef2b0d95252731bdafe351ce406d7d33233bb2dfcd020951` | `MAPPING_ONLY` |
| `D593a` | `complete` | 4 | `9054-9080` | `fbbce463e05c62b6ef2b0d95252731bdafe351ce406d7d33233bb2dfcd020951` | `NO_SEMANTIC_IMPACT` |
| `D594` | `complete` | 9 | `9081-9097` | `cbfe112a803e6f384fd791db34a0857d881268c1c074b758ff8071e509c02363` | `MAPPING_ONLY` |
| `D595` | `complete` | 9 | `9098-9115` | `509a0ee55683b0ff388ec9af7de0d241fd6a0902e78f1cf15c86f5af3f61ee08` | `MAPPING_ONLY` |
| `D596` | `complete` | 9 | `9116-9137` | `cae1136f3afc8545bccd700e4ac7ee248abc86d9b5c7fe41b60502134a858fa2` | `MAPPING_ONLY` |
| `D596a` | `complete` | 4 | `9116-9137` | `cae1136f3afc8545bccd700e4ac7ee248abc86d9b5c7fe41b60502134a858fa2` | `MAPPING_ONLY` |
| `D597` | `complete` | 9 | `9149-9162` | `f78511f15740d1ab9670295afd3ecfa011ca98de49cf1e5c1e71723f3eb6342d` | `MAPPING_ONLY` |
| `D598` | `complete` | 4 | `9163-9178` | `620e0cfb1518dcc4329e38bf1994b05e05be3215371fc92ee694a850ce6e240b` | `NO_SEMANTIC_IMPACT` |
| `D599` | `complete` | 8 | `9179-9196` | `6b9574f7a2db423af438f880c363f6480a26f2f8a77be798a14029e5feeda5a2` | `MAPPING_ONLY` |
| `D600` | `complete` | 6 | `9197-9214` | `04bac9caffb484737fb41d7b8607a4014548bec7553b6f22322f1b4bfe7723e0` | `MAPPING_ONLY` |
| `D601` | `complete` | 6 | `9215-9230` | `d4ae3f96558ae19061c565f7461bc8acd14e61fa3de9aa5de9b945e04a5e1ff9` | `NO_SEMANTIC_IMPACT` |
| `D602` | `complete` | 8 | `9231-9264` | `f2c8ec7c7e0af9066f8cd7f4b150ee2f747d5e30cf09423a1d9b9539dca53b47` | `NO_SEMANTIC_IMPACT` |
| `D603` | `complete` | 5 | `9265-9277` | `0d36d8d2144201031f37f5bce6290d609ec612659643a697c75258c736d035ad` | `MODEL_AFFECTING` |
| `D604` | `complete` | 5 | `9278-9294` | `9752428064d080251e9bfdddbb85a6775be83df4fcdaded65685aaef7ce4d1dc` | `MODEL_AFFECTING` |
| `D605` | `complete` | 8 | `9278-9294` | `9752428064d080251e9bfdddbb85a6775be83df4fcdaded65685aaef7ce4d1dc` | `NO_SEMANTIC_IMPACT` |
| `D606` | `complete` | 5 | `9295-9307` | `ac3c2f4026733f20e265c6e04c3942016672c6e53d12209093cf2896a0f711e0` | `MODEL_AFFECTING` |
| `D607` | `complete` | 7 | `9308-9327` | `54f41e93c806c80b4930ff7856c78cbdf9b850564af394e7c409ccbd94056e90` | `MODEL_AFFECTING` |
| `D608` | `complete` | 5 | `9328-9334` | `d5a9615ba2c70fc5bde77074e689012e089998cd859c7cdc1f9f1f01d196c1a5` | `MODEL_AFFECTING` |
| `D609` | `superseded` by `D585` | 0 | n/a | n/a | `NO_SEMANTIC_IMPACT` |
| `D610` | `complete` | 5 | `9335-9347` | `1a36a6aee220a1be039e0d6e956904003db3f8f404d8436ea0ffa4606652329c` | `MODEL_AFFECTING` |
| `D611` | `complete` | 8 | `9348-9359` | `62e95227b7dc8b9c5fcac8b5f63dc19a2eb48b52ba89a614ca4c0b51174a38f0` | `NO_SEMANTIC_IMPACT` |
| `D612` | `complete` | 4 | `9360-9376` | `f03b88ead412fef1989c2b93dad50949c182efa1f910e5a6122940c51f563122` | `NO_SEMANTIC_IMPACT` |
| `D613` | `superseded` by `D581` | 0 | n/a | n/a | `NO_SEMANTIC_IMPACT` |
| `D614` | `complete` | 4 | `9377-9391` | `57be1706b623c4cd6114a2956fc8ebe5be16cde3111d09a1de58772a88598321` | `NO_SEMANTIC_IMPACT` |
| `D615` | `complete` | 8 | `9401-9449` | `c7083a32fcbf24e8fc82e64dc49df40320bfd1ac92261e5a3dda717bf76c0082` | `MAPPING_ONLY` |
| `D616` | `complete` | 8 | `9450-9475` | `926675c4ea4ab04dadfdea1c2990b8548908bc4b1f72b9c126aede685d2937ab` | `MAPPING_ONLY` |
| `D617` | `superseded` by `D527/D545/D590` | 0 | n/a | n/a | `NO_SEMANTIC_IMPACT` |
| `D618` | `complete` | 8 | `9487-9526` | `2aba5c329953530acdaa5880f92e70c491288b9ae1a11dd64820b37cfe073d56` | `MAPPING_ONLY` |
| `D619` | `complete` | 6 | `9527-9549` | `f3ee61a80b3038449fba3c16513a413b4e6ae0b0549e74386edc6fdc0f5349c0` | `NO_SEMANTIC_IMPACT` |
| `D620` | `complete` | 6 | `9550-9568` | `3e3e9acfea037be6428f33aec1d2c5dc3affab8713805c9ab4a9dd383bb29983` | `NO_SEMANTIC_IMPACT` |
| `D621` | `complete` | 8 | `9569-9587` | `423977c32fa44e3333ddee703255b806b599575de25e7024bbf5ab7383d9245d` | `MAPPING_ONLY` |
| `D622` | `superseded` by `D531-D536/D569a-D569c` | 0 | n/a | n/a | `NO_SEMANTIC_IMPACT` |
| `D623` | `complete` | 6 | `9588-9610` | `f1bc90b311ba39b2e07e828304b8bde870937ee9bd3d2f3ecc8d3974a7dd2f76` | `NO_SEMANTIC_IMPACT` |
| `D624` | `complete` | 9 | `9611-9639` | `ce5eafd5d5d3c567ff2170130117a3d27fa28a772de2d307f316c216980b8dba` | `MAPPING_ONLY` |
| `D624a` | `complete` | 9 | `9640-9721` | `0f8b50929d892929657e834ecc1188f08dbe8f43b56a4e82cca9b00c02bc0b7e` | `MAPPING_ONLY` |
| `D625` | `complete` | 4 | `9722-9768` | `5bea3145bd46f509aac09d4b09f27c913ed6ee9581490938d506ddb8aea08b60` | `NO_SEMANTIC_IMPACT` |
| `D626` | `superseded` by `D596a` | 0 | n/a | n/a | `NO_SEMANTIC_IMPACT` |

## D558

Accepted source heading: `### D558: Closed Callable Effect Evidence` at `kyokaidecided.md:8218-8225`.

Accepted-source SHA-256: `559e08417b2b94d92d185fccf052c6cda81dc9f85d5b2302cd965c3710dff205`.

Destinations: `kyokaispec/src/language/07-generics-and-typeclasses.md`, `kyokaispec/src/toolchain/02-module-resolution-and-koi.md`.

Proof impact: `MODEL_AFFECTING`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D558.syntax-api` | `syntax-api` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D558.static` | `static` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D558.dynamic` | `dynamic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D558.ownership` | `ownership` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D558.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D558.capability` | `capability` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D558.failure` | `failure` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D558.artifact` | `artifact` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D558.diagnostic` | `diagnostic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D558.compatibility` | `compatibility` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D558.target` | `target` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D558.example` | `example` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D558.illegal-form` | `illegal-form` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D558.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D559

Accepted source heading: `### D559: Mutable-Borrow Token Copies Share One Lease Lineage` at `kyokaidecided.md:8226-8233`.

Accepted-source SHA-256: `9fc24347fc4916dca0e9ff9baa2ce0a988336340306051acf890f25a0bf39f24`.

Destinations: `kyokaispec/src/language/11-linearity-borrowing-and-regions.md`, `kyokaispec/src/project/03-formalization-roadmap.md`.

Proof impact: `MODEL_AFFECTING`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D559.syntax-api` | `syntax-api` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D559.static` | `static` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D559.dynamic` | `dynamic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D559.ownership` | `ownership` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D559.borrow` | `borrow` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D559.capability` | `capability` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D559.failure` | `failure` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D559.artifact` | `artifact` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D559.diagnostic` | `diagnostic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D559.compatibility` | `compatibility` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D559.target` | `target` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D559.example` | `example` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D559.illegal-form` | `illegal-form` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D559.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D560

Accepted source heading: `### D560: Declared `Free` Types Are Structurally Checked` at `kyokaidecided.md:8234-8241`.

Accepted-source SHA-256: `c6fb5be86504c4643acc9bd5e2c68ac6628014d2c730d0423c09abae425eee92`.

Destinations: `kyokaispec/src/language/06-type-system.md`, `kyokaispec/src/toolchain/02-module-resolution-and-koi.md`.

Proof impact: `MODEL_AFFECTING`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D560.syntax-api` | `syntax-api` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D560.static` | `static` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D560.dynamic` | `dynamic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D560.ownership` | `ownership` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D560.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D560.capability` | `capability` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D560.failure` | `failure` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D560.artifact` | `artifact` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D560.diagnostic` | `diagnostic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D560.compatibility` | `compatibility` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D560.target` | `target` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D560.example` | `example` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D560.illegal-form` | `illegal-form` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D560.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D561

Accepted source heading: `### D561: Process-Wide Fatal Arbitration` at `kyokaidecided.md:8242-8249`.

Accepted-source SHA-256: `406f298bb7394cf4289baf1b8147caab7173d030b3a26fb6fb6bc31e397070d1`.

Destinations: `kyokaispec/src/language/13-contracts-and-runtime-failure.md`, `kyokaispec/src/language/15-concurrency.md`.

Proof impact: `MODEL_AFFECTING`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D561.syntax-api` | `syntax-api` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D561.static` | `static` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D561.dynamic` | `dynamic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D561.ownership` | `ownership` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D561.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D561.capability` | `capability` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D561.failure` | `failure` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D561.artifact` | `artifact` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D561.diagnostic` | `diagnostic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D561.compatibility` | `compatibility` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D561.target` | `target` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D561.example` | `example` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D561.illegal-form` | `illegal-form` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D561.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D562

Accepted source heading: `### D562: Accepted D-Point Authority And Workspace Root Repair` at `kyokaidecided.md:8250-8255`.

Accepted-source SHA-256: `ee306a63a899b5bead79b204a83c8f1365626a6b390dae4085aadebc50028215`.

Destinations: `kyokaispec/src/toolchain/01-manifest-package-workspace.md`, `kyokaispec/src/project/01-governance.md`.

Proof impact: `NO_SEMANTIC_IMPACT`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D562.syntax-api` | `syntax-api` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D562.static` | `static` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D562.dynamic` | `dynamic` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D562.ownership` | `ownership` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D562.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D562.capability` | `capability` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D562.failure` | `failure` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D562.artifact` | `artifact` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D562.diagnostic` | `diagnostic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D562.compatibility` | `compatibility` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D562.target` | `target` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D562.example` | `example` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D562.illegal-form` | `illegal-form` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D562.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D562a

Accepted source heading: `### D562a: Monthly And Release-Bound Specification Review` at `kyokaidecided.md:8256-8263`.

Accepted-source SHA-256: `8dd2d6c96fe5ea16c0e98a70849ad3bf7b9c034f41c143405b99837a6faf6946`.

Destinations: `kyokaispec/src/project/01-governance.md`, `kyokaispec/src/project/02-decision-traceability.md`.

Proof impact: `NO_SEMANTIC_IMPACT`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D562a.syntax-api` | `syntax-api` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D562a.static` | `static` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D562a.dynamic` | `dynamic` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D562a.ownership` | `ownership` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D562a.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D562a.capability` | `capability` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D562a.failure` | `failure` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D562a.artifact` | `artifact` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D562a.diagnostic` | `diagnostic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D562a.compatibility` | `compatibility` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D562a.target` | `target` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D562a.example` | `example` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D562a.illegal-form` | `illegal-form` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D562a.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D563

Accepted source heading: `### D563: Independently Projectable Record Fields` at `kyokaidecided.md:8264-8269`.

Accepted-source SHA-256: `9e4ce8ba1dc413fc806c9a7928da18a397d5da77ec21972b5a430fbf2dbed2c8`.

Destinations: `kyokaispec/src/language/03-grammar.md`, `kyokaispec/src/language/06-type-system.md`.

Proof impact: `MODEL_AFFECTING`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D563.syntax-api` | `syntax-api` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D563.static` | `static` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D563.dynamic` | `dynamic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D563.ownership` | `ownership` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D563.borrow` | `borrow` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D563.capability` | `capability` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D563.failure` | `failure` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D563.artifact` | `artifact` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D563.diagnostic` | `diagnostic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D563.compatibility` | `compatibility` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D563.target` | `target` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D563.example` | `example` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D563.illegal-form` | `illegal-form` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D563.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D564

Accepted source heading: `### D564: Authority Enforcement Is Not Native Containment` at `kyokaidecided.md:8270-8277`.

Accepted-source SHA-256: `9ede8e7305ec5050d20a86a19c26aeb38a7a4d9152aecddae9cb6c522aac9dea`.

Destinations: `kyokaispec/src/language/14-capabilities-and-authority.md`, `kyokaispec/src/language/16-unsafe-ffi-and-abi.md`.

Proof impact: `MODEL_AFFECTING`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D564.syntax-api` | `syntax-api` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D564.static` | `static` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D564.dynamic` | `dynamic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D564.ownership` | `ownership` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D564.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D564.capability` | `capability` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D564.failure` | `failure` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D564.artifact` | `artifact` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D564.diagnostic` | `diagnostic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D564.compatibility` | `compatibility` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D564.target` | `target` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D564.example` | `example` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D564.illegal-form` | `illegal-form` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D564.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D565

Accepted source heading: `### D565: No Kyokai Undefined Behavior, Including Unsafe Kyokai` at `kyokaidecided.md:8278-8287`.

Accepted-source SHA-256: `dce53dad036dadf4932347cc75ab7553a6095f8f5bb4ab930eff91d06e6c3417`.

Destinations: `kyokaispec/src/language/16-unsafe-ffi-and-abi.md`, `kyokaispec/src/language/17-memory-layout-and-backend-contract.md`.

Proof impact: `MODEL_AFFECTING`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D565.syntax-api` | `syntax-api` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D565.static` | `static` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D565.dynamic` | `dynamic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D565.ownership` | `ownership` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D565.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D565.capability` | `capability` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D565.failure` | `failure` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D565.artifact` | `artifact` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D565.diagnostic` | `diagnostic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D565.compatibility` | `compatibility` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D565.target` | `target` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D565.example` | `example` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D565.illegal-form` | `illegal-form` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D565.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D566

Accepted source heading: `### D566: Unsafe Capability Topology` at `kyokaidecided.md:8288-8293`.

Accepted-source SHA-256: `d580b0aa4db5279c98fac063460879bb911af2835b80ba958b5ece43e8d1aef1`.

Destinations: `kyokaispec/src/language/14-capabilities-and-authority.md`, `kyokaispec/src/language/16-unsafe-ffi-and-abi.md`.

Proof impact: `MODEL_AFFECTING`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D566.syntax-api` | `syntax-api` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D566.static` | `static` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D566.dynamic` | `dynamic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D566.ownership` | `ownership` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D566.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D566.capability` | `capability` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D566.failure` | `failure` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D566.artifact` | `artifact` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D566.diagnostic` | `diagnostic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D566.compatibility` | `compatibility` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D566.target` | `target` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D566.example` | `example` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D566.illegal-form` | `illegal-form` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D566.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D567

Accepted source heading: `### D567: Canonical Callable Invocation Classes` at `kyokaidecided.md:8294-8301`.

Accepted-source SHA-256: `d5312668f83aee40c51d989810d334161b6b9fce15543942380bce0ad202d640`.

Destinations: `kyokaispec/src/language/07-generics-and-typeclasses.md`, `kyokaispec/src/language/11-linearity-borrowing-and-regions.md`, `kyokaispec/src/language/16-unsafe-ffi-and-abi.md`.

Proof impact: `MODEL_AFFECTING`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D567.syntax-api` | `syntax-api` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D567.static` | `static` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D567.dynamic` | `dynamic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D567.ownership` | `ownership` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D567.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D567.capability` | `capability` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D567.failure` | `failure` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D567.artifact` | `artifact` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D567.diagnostic` | `diagnostic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D567.compatibility` | `compatibility` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D567.target` | `target` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D567.example` | `example` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D567.illegal-form` | `illegal-form` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D567.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D568

Accepted source heading: `### D568: Validate Untrusted Input Before Hard-Stop Domains` at `kyokaidecided.md:8302-8307`.

Accepted-source SHA-256: `c9afd42b09e73bdcaf322e7a464633e9b65cdabe4e162822d9e9a9d09abfc5d2`.

Destinations: `kyokaispec/src/language/13-contracts-and-runtime-failure.md`.

Proof impact: `MODEL_AFFECTING`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D568.syntax-api` | `syntax-api` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D568.static` | `static` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D568.dynamic` | `dynamic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D568.ownership` | `ownership` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D568.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D568.capability` | `capability` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D568.failure` | `failure` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D568.artifact` | `artifact` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D568.diagnostic` | `diagnostic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D568.compatibility` | `compatibility` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D568.target` | `target` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D568.example` | `example` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D568.illegal-form` | `illegal-form` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D568.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D569

Accepted source heading: `### D569: Kyokai-Owned Atomic Execution Model` at `kyokaidecided.md:8308-8313`.

Accepted-source SHA-256: `189d64e23bfa2a441015a03eec54e9ab44e2e66d37559b26e630ee42fead4658`.

Destinations: `kyokaispec/src/language/15-concurrency.md`, `kyokaispec/src/language/17-memory-layout-and-backend-contract.md`.

Proof impact: `MODEL_AFFECTING`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D569.syntax-api` | `syntax-api` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D569.static` | `static` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D569.dynamic` | `dynamic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D569.ownership` | `ownership` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D569.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D569.capability` | `capability` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D569.failure` | `failure` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D569.artifact` | `artifact` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D569.diagnostic` | `diagnostic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D569.compatibility` | `compatibility` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D569.target` | `target` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D569.example` | `example` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D569.illegal-form` | `illegal-form` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D569.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D569a

Accepted source heading: `### D569a: Shared Semantic Corpus For C-Compiler Admission` at `kyokaidecided.md:8314-8319`.

Accepted-source SHA-256: `ea4ec89483e647b0e4e423a69326cfb75549d4c3b6c7b1daa9864af369b01ae0`.

Destinations: `kyokaispec/src/toolchain/04-build-profiles-targets-linking.md`, `kyokaispec/src/toolchain/07-testing-coverage-bench.md`.

Proof impact: `MAPPING_ONLY`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D569a.syntax-api` | `syntax-api` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D569a.static` | `static` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D569a.dynamic` | `dynamic` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D569a.ownership` | `ownership` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D569a.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D569a.capability` | `capability` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D569a.failure` | `failure` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D569a.artifact` | `artifact` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D569a.diagnostic` | `diagnostic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D569a.compatibility` | `compatibility` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D569a.target` | `target` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D569a.example` | `example` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D569a.illegal-form` | `illegal-form` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D569a.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D569b

Accepted source heading: `### D569b: Exact Admission Matrix` at `kyokaidecided.md:8320-8325`.

Accepted-source SHA-256: `ded59c7170edcc82150a6b3768949a9bfbba7c80f254fa904f819b1589bc4a20`.

Destinations: `kyokaispec/src/toolchain/04-build-profiles-targets-linking.md`.

Proof impact: `MAPPING_ONLY`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D569b.syntax-api` | `syntax-api` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D569b.static` | `static` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D569b.dynamic` | `dynamic` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D569b.ownership` | `ownership` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D569b.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D569b.capability` | `capability` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D569b.failure` | `failure` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D569b.artifact` | `artifact` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D569b.diagnostic` | `diagnostic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D569b.compatibility` | `compatibility` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D569b.target` | `target` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D569b.example` | `example` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D569b.illegal-form` | `illegal-form` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D569b.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D569c

Accepted source heading: `### D569c: Admission Lifecycle And Self-Verification` at `kyokaidecided.md:8326-8335`.

Accepted-source SHA-256: `40f679b968a076540e6df2e6cca1f8632d0c4e7a3631056b41397002121f5362`.

Destinations: `kyokaispec/src/toolchain/04-build-profiles-targets-linking.md`, `kyokaispec/src/toolchain/07-testing-coverage-bench.md`.

Proof impact: `MAPPING_ONLY`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D569c.syntax-api` | `syntax-api` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D569c.static` | `static` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D569c.dynamic` | `dynamic` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D569c.ownership` | `ownership` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D569c.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D569c.capability` | `capability` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D569c.failure` | `failure` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D569c.artifact` | `artifact` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D569c.diagnostic` | `diagnostic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D569c.compatibility` | `compatibility` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D569c.target` | `target` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D569c.example` | `example` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D569c.illegal-form` | `illegal-form` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D569c.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D570

Accepted source heading: `### D570: Canonical Source-Tree Identity (`KST-1`)` at `kyokaidecided.md:8336-8347`.

Accepted-source SHA-256: `5726edacfa3c5c5067f2c96d99480505304ee3c9f19241c22eebcd4d354bcdbd`.

Destinations: `kyokaispec/src/toolchain/09-reproducibility-incremental-builds.md`, `kyokaispec/src/toolchain/04-build-profiles-targets-linking.md`.

Proof impact: `MAPPING_ONLY`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D570.syntax-api` | `syntax-api` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D570.static` | `static` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D570.dynamic` | `dynamic` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D570.ownership` | `ownership` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D570.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D570.capability` | `capability` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D570.failure` | `failure` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D570.artifact` | `artifact` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D570.diagnostic` | `diagnostic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D570.compatibility` | `compatibility` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D570.target` | `target` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D570.example` | `example` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D570.illegal-form` | `illegal-form` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D570.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D571

Accepted source heading: `### D571: Structured Task Child Reclamation` at `kyokaidecided.md:8454-8486`.

Accepted-source SHA-256: `df15c459d7b6b3a13e652f90c2842e4924e8631cbd2f1c9b81b503d940d6d44e`.

Destinations: `kyokaispec/src/language/15-concurrency.md`, `kyokaispec/src/stdlib/09-concurrency-primitives.md`.

Proof impact: `MODEL_AFFECTING`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D571.syntax-api` | `syntax-api` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D571.static` | `static` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D571.dynamic` | `dynamic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D571.ownership` | `ownership` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D571.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D571.capability` | `capability` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D571.failure` | `failure` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D571.artifact` | `artifact` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D571.diagnostic` | `diagnostic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D571.compatibility` | `compatibility` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D571.target` | `target` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D571.example` | `example` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D571.illegal-form` | `illegal-form` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D571.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D572

Accepted source heading: `### D572: Generated-C Semantic Preservation And Translation Validation` at `kyokaidecided.md:8487-8511`.

Accepted-source SHA-256: `5ad5a44d252d0285122c8aebbb8738bcd534d17be209f9b8f3486c070c953a49`.

Destinations: `kyokaispec/src/language/17-memory-layout-and-backend-contract.md`, `kyokaispec/src/toolchain/04-build-profiles-targets-linking.md`.

Proof impact: `MAPPING_ONLY`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D572.syntax-api` | `syntax-api` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D572.static` | `static` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D572.dynamic` | `dynamic` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D572.ownership` | `ownership` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D572.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D572.capability` | `capability` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D572.failure` | `failure` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D572.artifact` | `artifact` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D572.diagnostic` | `diagnostic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D572.compatibility` | `compatibility` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D572.target` | `target` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D572.example` | `example` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D572.illegal-form` | `illegal-form` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D572.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D573

Accepted source heading: `### D573: KBI-1 Bounds-Checkable Container Framing` at `kyokaidecided.md:8512-8537`.

Accepted-source SHA-256: `99e976f0205f39329a0345160ef6e33a4e731464772413dda116dfd3c2edd97d`.

Destinations: `kyokaispec/src/toolchain/02-module-resolution-and-koi.md`.

Proof impact: `MAPPING_ONLY`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D573.syntax-api` | `syntax-api` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D573.static` | `static` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D573.dynamic` | `dynamic` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D573.ownership` | `ownership` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D573.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D573.capability` | `capability` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D573.failure` | `failure` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D573.artifact` | `artifact` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D573.diagnostic` | `diagnostic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D573.compatibility` | `compatibility` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D573.target` | `target` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D573.example` | `example` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D573.illegal-form` | `illegal-form` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D573.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D573a

Accepted source heading: `### D573a: Native Linux `io_uring` Provider` at `kyokaidecided.md:8538-8582`.

Accepted-source SHA-256: `3125bc82fd8639dc8dfc638c01589a91b2dcab91c64066c9f11fa533709967bd`.

Destinations: `kyokaispec/src/language/14-capabilities-and-authority.md`, `kyokaispec/src/language/15-concurrency.md`, `kyokaispec/src/stdlib/08-io-files-env-process-time-random.md`, `kyokaispec/src/stdlib/09-concurrency-primitives.md`.

Proof impact: `MODEL_AFFECTING`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D573a.syntax-api` | `syntax-api` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D573a.static` | `static` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D573a.dynamic` | `dynamic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D573a.ownership` | `ownership` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D573a.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D573a.capability` | `capability` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D573a.failure` | `failure` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D573a.artifact` | `artifact` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D573a.diagnostic` | `diagnostic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D573a.compatibility` | `compatibility` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D573a.target` | `target` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D573a.example` | `example` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D573a.illegal-form` | `illegal-form` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D573a.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D574

Accepted source heading: `### D574: KBI-1 Canonical Semantic Payload Grammar` at `kyokaidecided.md:8583-8604`.

Accepted-source SHA-256: `b3a9c7f1beb31c93d353daf0852be7d4c3937067c49c5e706aa6236b65cd4773`.

Destinations: `kyokaispec/src/toolchain/02-module-resolution-and-koi.md`.

Proof impact: `MAPPING_ONLY`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D574.syntax-api` | `syntax-api` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D574.static` | `static` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D574.dynamic` | `dynamic` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D574.ownership` | `ownership` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D574.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D574.capability` | `capability` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D574.failure` | `failure` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D574.artifact` | `artifact` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D574.diagnostic` | `diagnostic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D574.compatibility` | `compatibility` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D574.target` | `target` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D574.example` | `example` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D574.illegal-form` | `illegal-form` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D574.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D575

Accepted source heading: `### D575: KBI-1 Hostile-Input Budgets` at `kyokaidecided.md:8605-8626`.

Accepted-source SHA-256: `cf54ca306200a53c9646b338b43d418bed299268ef3b4651e2435e2fa06d0732`.

Destinations: `kyokaispec/src/toolchain/02-module-resolution-and-koi.md`, `kyokaispec/src/toolchain/07-testing-coverage-bench.md`.

Proof impact: `MAPPING_ONLY`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D575.syntax-api` | `syntax-api` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D575.static` | `static` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D575.dynamic` | `dynamic` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D575.ownership` | `ownership` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D575.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D575.capability` | `capability` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D575.failure` | `failure` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D575.artifact` | `artifact` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D575.diagnostic` | `diagnostic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D575.compatibility` | `compatibility` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D575.target` | `target` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D575.example` | `example` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D575.illegal-form` | `illegal-form` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D575.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D576

Accepted source heading: `### D576: KBI-1 Stability And Independent Decoder Admission` at `kyokaidecided.md:8627-8650`.

Accepted-source SHA-256: `87537efadfec315d3489c2e881d7e2fa87ff91d6229d56857559be704859952f`.

Destinations: `kyokaispec/src/toolchain/02-module-resolution-and-koi.md`, `kyokaispec/src/toolchain/10-package-index-semver-releases-ci.md`.

Proof impact: `MAPPING_ONLY`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D576.syntax-api` | `syntax-api` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D576.static` | `static` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D576.dynamic` | `dynamic` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D576.ownership` | `ownership` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D576.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D576.capability` | `capability` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D576.failure` | `failure` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D576.artifact` | `artifact` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D576.diagnostic` | `diagnostic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D576.compatibility` | `compatibility` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D576.target` | `target` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D576.example` | `example` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D576.illegal-form` | `illegal-form` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D576.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D577

Accepted source heading: `### D577: Clause-Level Specification Extraction Evidence` at `kyokaidecided.md:8651-8675`.

Accepted-source SHA-256: `6b24549523ff3ef16b4f5c20dc959bce778b24f453f5cf318055ebb851f9a9fc`.

Destinations: `kyokaispec/src/project/01-governance.md`, `kyokaispec/src/project/02-decision-traceability.md`, `PROJECT_STANDARDS.md`, `docs/contributing/spec-writing.md`.

Proof impact: `NO_SEMANTIC_IMPACT`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D577.syntax-api` | `syntax-api` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D577.static` | `static` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D577.dynamic` | `dynamic` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D577.ownership` | `ownership` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D577.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D577.capability` | `capability` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D577.failure` | `failure` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D577.artifact` | `artifact` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D577.diagnostic` | `diagnostic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D577.compatibility` | `compatibility` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D577.target` | `target` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D577.example` | `example` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D577.illegal-form` | `illegal-form` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D577.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D578

Accepted source heading: `### D578: Public Document Identity And Version Axes` at `kyokaidecided.md:8676-8693`.

Accepted-source SHA-256: `b2f17b25d73a820dbd6de1f233101d2378193c804f9162cdca2aae289fd71e2b`.

Destinations: `kyokaispec/src/project/01-governance.md`, `kyokaispec/src/project/02-decision-traceability.md`.

Proof impact: `NO_SEMANTIC_IMPACT`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D578.syntax-api` | `syntax-api` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D578.static` | `static` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D578.dynamic` | `dynamic` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D578.ownership` | `ownership` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D578.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D578.capability` | `capability` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D578.failure` | `failure` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D578.artifact` | `artifact` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D578.diagnostic` | `diagnostic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D578.compatibility` | `compatibility` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D578.target` | `target` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D578.example` | `example` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D578.illegal-form` | `illegal-form` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D578.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D579

Accepted source heading: `### D579: Generated Semantic Atlas` at `kyokaidecided.md:8694-8718`.

Accepted-source SHA-256: `0683b7801746d32f8cc5b421ed5921bb542a23c477589497b7ea905ba3de6e5f`.

Destinations: `kyokaispec/src/toolchain/08-docs-lsp-audit.md`, `kyokaispec/src/rationale/00-rationale-index.md`.

Proof impact: `NO_SEMANTIC_IMPACT`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D579.syntax-api` | `syntax-api` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D579.static` | `static` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D579.dynamic` | `dynamic` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D579.ownership` | `ownership` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D579.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D579.capability` | `capability` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D579.failure` | `failure` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D579.artifact` | `artifact` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D579.diagnostic` | `diagnostic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D579.compatibility` | `compatibility` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D579.target` | `target` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D579.example` | `example` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D579.illegal-form` | `illegal-form` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D579.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D580

Accepted source heading: `### D580: Bidirectional Specification–Calculus Correspondence` at `kyokaidecided.md:8719-8748`.

Accepted-source SHA-256: `baa463bbb6d1358a03c263f3671bcc338d4e200e7efb38bd8fb50f0926147031`.

Destinations: `kyokaispec/src/project/03-formalization-roadmap.md`, `kyokaicalculus/findings-divergence.md`, `PROJECT_STANDARDS.md`, `docs/contributing/spec-writing.md`.

Proof impact: `MAPPING_ONLY`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D580.syntax-api` | `syntax-api` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D580.static` | `static` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D580.dynamic` | `dynamic` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D580.ownership` | `ownership` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D580.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D580.capability` | `capability` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D580.failure` | `failure` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D580.artifact` | `artifact` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D580.diagnostic` | `diagnostic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D580.compatibility` | `compatibility` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D580.target` | `target` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D580.example` | `example` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D580.illegal-form` | `illegal-form` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D580.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D581

Accepted source heading: `### D581: Revision-Bound Proof Review Artifacts` at `kyokaidecided.md:8749-8767`.

Accepted-source SHA-256: `aff99bb46ee4d792840065b4cdfa91ac471d432ab529e65fde6d3d6d52c86b5d`.

Destinations: `kyokaispec/src/project/03-formalization-roadmap.md`, `kyokaicalculus/claim-tiers.md`, `kyokaicalculus/reviews/README.md`, `phase.md`, `kyokaiproofstatus.toml`.

Proof impact: `NO_SEMANTIC_IMPACT`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D581.syntax-api` | `syntax-api` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D581.static` | `static` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D581.dynamic` | `dynamic` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D581.ownership` | `ownership` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D581.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D581.capability` | `capability` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D581.failure` | `failure` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D581.artifact` | `artifact` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D581.diagnostic` | `diagnostic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D581.compatibility` | `compatibility` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D581.target` | `target` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D581.example` | `example` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D581.illegal-form` | `illegal-form` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D581.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D582

Accepted source heading: `### D582: Experiment Points And Xperimental Releases **[AMENDED BY D625: production-quality experiments can be carried disabled in stable toolchains under exact root-manifest opt-in]**` at `kyokaidecided.md:8768-8809`.

Accepted-source SHA-256: `6ae9fc363f68400dbacfc1aff1945ba8e799b97cd1ef05e341ab249f391e4617`.

Destinations: `PROJECT_STANDARDS.md`, `CODE_STANDARDS.md`, `kyokaispec/src/toolchain/01-manifest-package-workspace.md`, `kyokaispec/src/toolchain/07-testing-coverage-bench.md`, `phase.md`.

Proof impact: `NO_SEMANTIC_IMPACT`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D582.syntax-api` | `syntax-api` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D582.static` | `static` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D582.dynamic` | `dynamic` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D582.ownership` | `ownership` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D582.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D582.capability` | `capability` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D582.failure` | `failure` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D582.artifact` | `artifact` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D582.diagnostic` | `diagnostic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D582.compatibility` | `compatibility` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D582.target` | `target` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D582.example` | `example` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D582.illegal-form` | `illegal-form` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D582.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D583

Accepted source heading: `### D583: Vulnerability Reporting And Incident Service` at `kyokaidecided.md:8810-8850`.

Accepted-source SHA-256: `62ba9264b905b0b46a34472b62fc94716db9083aaeddbf14f5346574e4c2179e`.

Destinations: `kyokaispec/src/toolchain/10-package-index-semver-releases-ci.md`, `docs/infrastructure/services.md`.

Proof impact: `NO_SEMANTIC_IMPACT`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D583.syntax-api` | `syntax-api` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D583.static` | `static` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D583.dynamic` | `dynamic` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D583.ownership` | `ownership` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D583.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D583.capability` | `capability` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D583.failure` | `failure` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D583.artifact` | `artifact` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D583.diagnostic` | `diagnostic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D583.compatibility` | `compatibility` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D583.target` | `target` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D583.example` | `example` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D583.illegal-form` | `illegal-form` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D583.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D584

Accepted source heading: `#### D584: Tier-One API Packets` at `kyokaidecided.md:8859-8876`.

Accepted-source SHA-256: `d2741c3c16d8e890aeb14c19f26d48b4b3e3eac19a019a27c1f931afda59dd88`.

Destinations: `kyokaispec/src/stdlib/00-stdlib-overview.md`, `kyokaispec/src/stdlib/01-admission-contracts.md`, `kyokaispec/src/stdlib/02-core-result-optional-display-error.md`.

Proof impact: `MAPPING_ONLY`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D584.syntax-api` | `syntax-api` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D584.static` | `static` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D584.dynamic` | `dynamic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D584.ownership` | `ownership` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D584.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D584.capability` | `capability` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D584.failure` | `failure` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D584.artifact` | `artifact` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D584.diagnostic` | `diagnostic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D584.compatibility` | `compatibility` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D584.target` | `target` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D584.example` | `example` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D584.illegal-form` | `illegal-form` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D584.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D585

Accepted source heading: `#### D585: Closed `TextView[R]` Call-Boundary Formation` at `kyokaidecided.md:8877-8895`.

Accepted-source SHA-256: `32a4396c2414190e18b04d8eea8ccfcc226d6f82a6d9ea1601558251de225a43`.

Destinations: `kyokaispec/src/language/12-implicit-completions-and-elaboration.md`, `kyokaispec/src/language/18-built-ins.md`, `kyokaispec/src/stdlib/04-text-bytes-paths-and-strings.md`.

Proof impact: `MODEL_AFFECTING`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D585.syntax-api` | `syntax-api` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D585.static` | `static` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D585.dynamic` | `dynamic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D585.ownership` | `ownership` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D585.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D585.capability` | `capability` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D585.failure` | `failure` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D585.artifact` | `artifact` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D585.diagnostic` | `diagnostic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D585.compatibility` | `compatibility` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D585.target` | `target` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D585.example` | `example` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D585.illegal-form` | `illegal-form` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D585.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D586

Accepted source heading: `#### D586: Reviewed Storage Foundation` at `kyokaidecided.md:8896-8910`.

Accepted-source SHA-256: `7e1813990c54b58e147152b7232c5bb6318f9ef6a6d5df61d6874cddbfa7499f`.

Destinations: `kyokaispec/src/stdlib/03-allocators-and-memory-containers.md`, `kyokaispec/src/language/11-linearity-borrowing-and-regions.md`.

Proof impact: `MAPPING_ONLY`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D586.syntax-api` | `syntax-api` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D586.static` | `static` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D586.dynamic` | `dynamic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D586.ownership` | `ownership` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D586.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D586.capability` | `capability` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D586.failure` | `failure` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D586.artifact` | `artifact` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D586.diagnostic` | `diagnostic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D586.compatibility` | `compatibility` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D586.target` | `target` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D586.example` | `example` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D586.illegal-form` | `illegal-form` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D586.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D587

Accepted source heading: `#### D587: Collection Families And Linear Ownership` at `kyokaidecided.md:8911-8926`.

Accepted-source SHA-256: `fb4b49f8dedd278d2e0b752a76d91fd3a1db138080d4e347811e1426b5cf67c4`.

Destinations: `kyokaispec/src/stdlib/05-collections.md`, `kyokaispec/src/language/11-linearity-borrowing-and-regions.md`.

Proof impact: `MAPPING_ONLY`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D587.syntax-api` | `syntax-api` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D587.static` | `static` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D587.dynamic` | `dynamic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D587.ownership` | `ownership` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D587.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D587.capability` | `capability` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D587.failure` | `failure` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D587.artifact` | `artifact` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D587.diagnostic` | `diagnostic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D587.compatibility` | `compatibility` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D587.target` | `target` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D587.example` | `example` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D587.illegal-form` | `illegal-form` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D587.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D588

Accepted source heading: `#### D588: First-Party CLI Schema And Parser` at `kyokaidecided.md:8927-8942`.

Accepted-source SHA-256: `17490a8e5f9b31ccf8a0ee116871450142d522c554b24cb97cf2033f7a954f96`.

Destinations: `kyokaispec/src/stdlib/08-io-files-env-process-time-random.md`, `kyokaispec/src/toolchain/03-cli.md`.

Proof impact: `MAPPING_ONLY`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D588.syntax-api` | `syntax-api` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D588.static` | `static` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D588.dynamic` | `dynamic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D588.ownership` | `ownership` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D588.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D588.capability` | `capability` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D588.failure` | `failure` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D588.artifact` | `artifact` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D588.diagnostic` | `diagnostic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D588.compatibility` | `compatibility` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D588.target` | `target` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D588.example` | `example` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D588.illegal-form` | `illegal-form` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D588.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D589

Accepted source heading: `#### D589: One Testing Evidence Protocol` at `kyokaidecided.md:8943-8958`.

Accepted-source SHA-256: `da678d1ff6c073b1e8c8454c81fd47840925159017f4b6a0c66e8334ac6b4415`.

Destinations: `kyokaispec/src/toolchain/07-testing-coverage-bench.md`, `kyokaispec/src/stdlib/01-admission-contracts.md`.

Proof impact: `MAPPING_ONLY`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D589.syntax-api` | `syntax-api` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D589.static` | `static` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D589.dynamic` | `dynamic` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D589.ownership` | `ownership` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D589.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D589.capability` | `capability` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D589.failure` | `failure` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D589.artifact` | `artifact` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D589.diagnostic` | `diagnostic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D589.compatibility` | `compatibility` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D589.target` | `target` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D589.example` | `example` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D589.illegal-form` | `illegal-form` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D589.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D590

Accepted source heading: `#### D590: Capability Registry And Authority Explanation` at `kyokaidecided.md:8959-8978`.

Accepted-source SHA-256: `92174dfb76a252b94ba34bae12bbffda725b0e9d3e82418ac96cb77bb373c5be`.

Destinations: `kyokaispec/src/language/14-capabilities-and-authority.md`, `kyokaispec/src/toolchain/03-cli.md`, `kyokaispec/src/toolchain/05-diagnostics.md`, `kyokaispec/src/toolchain/08-docs-lsp-audit.md`.

Proof impact: `MAPPING_ONLY`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D590.syntax-api` | `syntax-api` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D590.static` | `static` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D590.dynamic` | `dynamic` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D590.ownership` | `ownership` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D590.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D590.capability` | `capability` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D590.failure` | `failure` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D590.artifact` | `artifact` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D590.diagnostic` | `diagnostic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D590.compatibility` | `compatibility` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D590.target` | `target` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D590.example` | `example` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D590.illegal-form` | `illegal-form` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D590.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D591

Accepted source heading: `#### D591: Explicit Observability Contracts` at `kyokaidecided.md:8979-8995`.

Accepted-source SHA-256: `192c34576a4aa2fa6e0f77aa0f1c79bb4cf44c150c757d673c422c690b465de8`.

Destinations: `kyokaispec/src/stdlib/08-io-files-env-process-time-random.md`, `kyokaispec/src/toolchain/05-diagnostics.md`.

Proof impact: `MAPPING_ONLY`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D591.syntax-api` | `syntax-api` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D591.static` | `static` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D591.dynamic` | `dynamic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D591.ownership` | `ownership` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D591.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D591.capability` | `capability` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D591.failure` | `failure` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D591.artifact` | `artifact` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D591.diagnostic` | `diagnostic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D591.compatibility` | `compatibility` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D591.target` | `target` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D591.example` | `example` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D591.illegal-form` | `illegal-form` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D591.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D592

Accepted source heading: `#### D592: Codec And Data-Format Placement` at `kyokaidecided.md:8996-9013`.

Accepted-source SHA-256: `1a71add2c059a7644790c1dbb31b5adc438867eea1f61d80d7391f782ac5b28e`.

Destinations: `kyokaispec/src/stdlib/01-admission-contracts.md`, `kyokaispec/src/stdlib/04-text-bytes-paths-and-strings.md`, `kyokaispec/src/toolchain/11-build-generation-and-playground.md`.

Proof impact: `MAPPING_ONLY`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D592.syntax-api` | `syntax-api` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D592.static` | `static` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D592.dynamic` | `dynamic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D592.ownership` | `ownership` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D592.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D592.capability` | `capability` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D592.failure` | `failure` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D592.artifact` | `artifact` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D592.diagnostic` | `diagnostic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D592.compatibility` | `compatibility` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D592.target` | `target` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D592.example` | `example` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D592.illegal-form` | `illegal-form` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D592.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D592a

Accepted source heading: `#### D592a: Gated Kyokai-Native Toolchain` at `kyokaidecided.md:9014-9053`.

Accepted-source SHA-256: `2c7139bead566ec42ef4c3c8256ebb61e268c0c843a7cecc36a3b28c7749dbc9`.

Destinations: `kyokaispec/src/toolchain/00-toolchain-overview.md`, `kyokaispec/src/toolchain/03-cli.md`, `kyokaispec/src/toolchain/09-reproducibility-incremental-builds.md`, `kyokaispec/src/project/03-formalization-roadmap.md`.

Proof impact: `NO_SEMANTIC_IMPACT`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D592a.syntax-api` | `syntax-api` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D592a.static` | `static` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D592a.dynamic` | `dynamic` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D592a.ownership` | `ownership` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D592a.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D592a.capability` | `capability` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D592a.failure` | `failure` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D592a.artifact` | `artifact` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D592a.diagnostic` | `diagnostic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D592a.compatibility` | `compatibility` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D592a.target` | `target` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D592a.example` | `example` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D592a.illegal-form` | `illegal-form` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D592a.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D593

Accepted source heading: `#### D593-D593a: Crypto Boundary And Admission Taxonomy` at `kyokaidecided.md:9054-9080`.

Accepted-source SHA-256: `fbbce463e05c62b6ef2b0d95252731bdafe351ce406d7d33233bb2dfcd020951`.

Destinations: `kyokaispec/src/stdlib/10-crypto-policy.md`, `kyokaispec/src/stdlib/11-transitional-ffi-tracking.md`.

Proof impact: `MAPPING_ONLY`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D593.syntax-api` | `syntax-api` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D593.static` | `static` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D593.dynamic` | `dynamic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D593.ownership` | `ownership` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D593.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D593.capability` | `capability` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D593.failure` | `failure` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D593.artifact` | `artifact` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D593.diagnostic` | `diagnostic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D593.compatibility` | `compatibility` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D593.target` | `target` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D593.example` | `example` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D593.illegal-form` | `illegal-form` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D593.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D593a

Accepted source heading: `#### D593-D593a: Crypto Boundary And Admission Taxonomy` at `kyokaidecided.md:9054-9080`.

Accepted-source SHA-256: `fbbce463e05c62b6ef2b0d95252731bdafe351ce406d7d33233bb2dfcd020951`.

Destinations: `kyokaispec/src/stdlib/01-admission-contracts.md`, `kyokaispec/src/stdlib/11-transitional-ffi-tracking.md`, `kyokaispec/src/toolchain/10-package-index-semver-releases-ci.md`.

Proof impact: `NO_SEMANTIC_IMPACT`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D593a.syntax-api` | `syntax-api` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D593a.static` | `static` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D593a.dynamic` | `dynamic` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D593a.ownership` | `ownership` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D593a.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D593a.capability` | `capability` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D593a.failure` | `failure` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D593a.artifact` | `artifact` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D593a.diagnostic` | `diagnostic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D593a.compatibility` | `compatibility` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D593a.target` | `target` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D593a.example` | `example` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D593a.illegal-form` | `illegal-form` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D593a.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D594

Accepted source heading: `#### D594: First-Party Web Protocol Foundation` at `kyokaidecided.md:9081-9097`.

Accepted-source SHA-256: `cbfe112a803e6f384fd791db34a0857d881268c1c074b758ff8071e509c02363`.

Destinations: `kyokaispec/src/stdlib/08-io-files-env-process-time-random.md`, `kyokaispec/src/stdlib/09-concurrency-primitives.md`, `kyokaispec/src/stdlib/12-application-integration-contracts.md`.

Proof impact: `MAPPING_ONLY`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D594.syntax-api` | `syntax-api` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D594.static` | `static` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D594.dynamic` | `dynamic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D594.ownership` | `ownership` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D594.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D594.capability` | `capability` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D594.failure` | `failure` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D594.artifact` | `artifact` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D594.diagnostic` | `diagnostic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D594.compatibility` | `compatibility` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D594.target` | `target` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D594.example` | `example` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D594.illegal-form` | `illegal-form` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D594.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D595

Accepted source heading: `#### D595: Database Ownership And Placement` at `kyokaidecided.md:9098-9115`.

Accepted-source SHA-256: `509a0ee55683b0ff388ec9af7de0d241fd6a0902e78f1cf15c86f5af3f61ee08`.

Destinations: `kyokaispec/src/stdlib/12-application-integration-contracts.md`, `kyokaispec/src/stdlib/11-transitional-ffi-tracking.md`.

Proof impact: `MAPPING_ONLY`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D595.syntax-api` | `syntax-api` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D595.static` | `static` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D595.dynamic` | `dynamic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D595.ownership` | `ownership` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D595.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D595.capability` | `capability` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D595.failure` | `failure` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D595.artifact` | `artifact` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D595.diagnostic` | `diagnostic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D595.compatibility` | `compatibility` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D595.target` | `target` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D595.example` | `example` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D595.illegal-form` | `illegal-form` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D595.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D596

Accepted source heading: `#### D596-D596a: Bridge Portfolio And Rust Boundary` at `kyokaidecided.md:9116-9137`.

Accepted-source SHA-256: `cae1136f3afc8545bccd700e4ac7ee248abc86d9b5c7fe41b60502134a858fa2`.

Destinations: `kyokaispec/src/stdlib/11-transitional-ffi-tracking.md`, `kyokaispec/src/stdlib/12-application-integration-contracts.md`, `kyokaispec/src/language/16-unsafe-ffi-and-abi.md`.

Proof impact: `MAPPING_ONLY`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D596.syntax-api` | `syntax-api` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D596.static` | `static` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D596.dynamic` | `dynamic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D596.ownership` | `ownership` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D596.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D596.capability` | `capability` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D596.failure` | `failure` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D596.artifact` | `artifact` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D596.diagnostic` | `diagnostic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D596.compatibility` | `compatibility` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D596.target` | `target` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D596.example` | `example` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D596.illegal-form` | `illegal-form` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D596.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D596a

Accepted source heading: `#### D596-D596a: Bridge Portfolio And Rust Boundary` at `kyokaidecided.md:9116-9137`.

Accepted-source SHA-256: `cae1136f3afc8545bccd700e4ac7ee248abc86d9b5c7fe41b60502134a858fa2`.

Destinations: `kyokaispec/src/toolchain/11-build-generation-and-playground.md`, `kyokaispec/src/rationale/01-language-design.md`, `kyokaispec/src/stdlib/11-transitional-ffi-tracking.md`.

Proof impact: `MAPPING_ONLY`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D596a.syntax-api` | `syntax-api` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D596a.static` | `static` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D596a.dynamic` | `dynamic` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D596a.ownership` | `ownership` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D596a.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D596a.capability` | `capability` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D596a.failure` | `failure` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D596a.artifact` | `artifact` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D596a.diagnostic` | `diagnostic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D596a.compatibility` | `compatibility` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D596a.target` | `target` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D596a.example` | `example` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D596a.illegal-form` | `illegal-form` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D596a.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D597

Accepted source heading: `#### D597: Fail-Closed Generator Host Admission` at `kyokaidecided.md:9149-9162`.

Accepted-source SHA-256: `f78511f15740d1ab9670295afd3ecfa011ca98de49cf1e5c1e71723f3eb6342d`.

Destinations: `kyokaispec/src/toolchain/11-build-generation-and-playground.md`, `kyokaispec/src/language/14-capabilities-and-authority.md`.

Proof impact: `MAPPING_ONLY`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D597.syntax-api` | `syntax-api` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D597.static` | `static` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D597.dynamic` | `dynamic` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D597.ownership` | `ownership` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D597.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D597.capability` | `capability` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D597.failure` | `failure` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D597.artifact` | `artifact` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D597.diagnostic` | `diagnostic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D597.compatibility` | `compatibility` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D597.target` | `target` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D597.example` | `example` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D597.illegal-form` | `illegal-form` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D597.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D598

Accepted source heading: `#### D598: Native Math Ownership And Replacement` at `kyokaidecided.md:9163-9178`.

Accepted-source SHA-256: `620e0cfb1518dcc4329e38bf1994b05e05be3215371fc92ee694a850ce6e240b`.

Destinations: `kyokaispec/src/stdlib/07-math-and-numerics.md`, `kyokaispec/src/stdlib/01-admission-contracts.md`.

Proof impact: `NO_SEMANTIC_IMPACT`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D598.syntax-api` | `syntax-api` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D598.static` | `static` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D598.dynamic` | `dynamic` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D598.ownership` | `ownership` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D598.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D598.capability` | `capability` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D598.failure` | `failure` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D598.artifact` | `artifact` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D598.diagnostic` | `diagnostic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D598.compatibility` | `compatibility` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D598.target` | `target` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D598.example` | `example` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D598.illegal-form` | `illegal-form` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D598.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D599

Accepted source heading: `#### D599: Shared-Lifetime Pattern Family And Explanation` at `kyokaidecided.md:9179-9196`.

Accepted-source SHA-256: `6b9574f7a2db423af438f880c363f6480a26f2f8a77be798a14029e5feeda5a2`.

Destinations: `kyokaispec/src/language/11-linearity-borrowing-and-regions.md`, `kyokaispec/src/toolchain/03-cli.md`.

Proof impact: `MAPPING_ONLY`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D599.syntax-api` | `syntax-api` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D599.static` | `static` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D599.dynamic` | `dynamic` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D599.ownership` | `ownership` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D599.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D599.capability` | `capability` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D599.failure` | `failure` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D599.artifact` | `artifact` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D599.diagnostic` | `diagnostic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D599.compatibility` | `compatibility` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D599.target` | `target` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D599.example` | `example` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D599.illegal-form` | `illegal-form` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D599.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D600

Accepted source heading: `#### D600: SPSC And Native-Task Topology Evidence` at `kyokaidecided.md:9197-9214`.

Accepted-source SHA-256: `04bac9caffb484737fb41d7b8607a4014548bec7553b6f22322f1b4bfe7723e0`.

Destinations: `kyokaispec/src/language/15-concurrency.md`, `kyokaispec/src/stdlib/09-concurrency-primitives.md`, `kyokaispec/src/toolchain/07-testing-coverage-bench.md`.

Proof impact: `MAPPING_ONLY`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D600.syntax-api` | `syntax-api` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D600.static` | `static` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D600.dynamic` | `dynamic` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D600.ownership` | `ownership` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D600.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D600.capability` | `capability` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D600.failure` | `failure` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D600.artifact` | `artifact` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D600.diagnostic` | `diagnostic` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D600.compatibility` | `compatibility` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D600.target` | `target` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D600.example` | `example` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D600.illegal-form` | `illegal-form` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D600.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D601

Accepted source heading: `#### D601: First Poller Reference Product` at `kyokaidecided.md:9215-9230`.

Accepted-source SHA-256: `d4ae3f96558ae19061c565f7461bc8acd14e61fa3de9aa5de9b945e04a5e1ff9`.

Destinations: `kyokaispec/src/project/06-reference-products-and-workloads.md`, `kyokaispec/src/toolchain/07-testing-coverage-bench.md`.

Proof impact: `NO_SEMANTIC_IMPACT`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D601.syntax-api` | `syntax-api` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D601.static` | `static` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D601.dynamic` | `dynamic` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D601.ownership` | `ownership` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D601.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D601.capability` | `capability` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D601.failure` | `failure` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D601.artifact` | `artifact` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D601.diagnostic` | `diagnostic` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D601.compatibility` | `compatibility` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D601.target` | `target` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D601.example` | `example` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D601.illegal-form` | `illegal-form` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D601.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D602

Accepted source heading: `#### D602: Repository-Owned Documentation Modes` at `kyokaidecided.md:9231-9264`.

Accepted-source SHA-256: `f2c8ec7c7e0af9066f8cd7f4b150ee2f747d5e30cf09423a1d9b9539dca53b47`.

Destinations: `kyokaispec/src/toolchain/01-manifest-package-workspace.md`, `kyokaispec/src/toolchain/08-docs-lsp-audit.md`, `kyokaispec/src/toolchain/10-package-index-semver-releases-ci.md`.

Proof impact: `NO_SEMANTIC_IMPACT`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D602.syntax-api` | `syntax-api` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D602.static` | `static` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D602.dynamic` | `dynamic` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D602.ownership` | `ownership` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D602.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D602.capability` | `capability` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D602.failure` | `failure` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D602.artifact` | `artifact` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D602.diagnostic` | `diagnostic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D602.compatibility` | `compatibility` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D602.target` | `target` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D602.example` | `example` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D602.illegal-form` | `illegal-form` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D602.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D603

Accepted source heading: `#### D603: Non-Authorizing `debug` Instrumentation` at `kyokaidecided.md:9265-9277`.

Accepted-source SHA-256: `0d36d8d2144201031f37f5bce6290d609ec612659643a697c75258c736d035ad`.

Destinations: `kyokaispec/src/language/10-statements-and-control-flow.md`, `kyokaispec/src/toolchain/05-diagnostics.md`.

Proof impact: `MODEL_AFFECTING`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D603.syntax-api` | `syntax-api` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D603.static` | `static` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D603.dynamic` | `dynamic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D603.ownership` | `ownership` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D603.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D603.capability` | `capability` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D603.failure` | `failure` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D603.artifact` | `artifact` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D603.diagnostic` | `diagnostic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D603.compatibility` | `compatibility` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D603.target` | `target` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D603.example` | `example` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D603.illegal-form` | `illegal-form` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D603.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D604

Accepted source heading: `#### D604-D605: Borrow Terminator And Layout Discipline` at `kyokaidecided.md:9278-9294`.

Accepted-source SHA-256: `9752428064d080251e9bfdddbb85a6775be83df4fcdaded65685aaef7ce4d1dc`.

Destinations: `kyokaispec/src/language/10-statements-and-control-flow.md`, `kyokaispec/src/toolchain/06-formatter.md`, `kyokaispec/src/toolchain/05-diagnostics.md`.

Proof impact: `MODEL_AFFECTING`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D604.syntax-api` | `syntax-api` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D604.static` | `static` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D604.dynamic` | `dynamic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D604.ownership` | `ownership` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D604.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D604.capability` | `capability` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D604.failure` | `failure` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D604.artifact` | `artifact` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D604.diagnostic` | `diagnostic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D604.compatibility` | `compatibility` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D604.target` | `target` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D604.example` | `example` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D604.illegal-form` | `illegal-form` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D604.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D605

Accepted source heading: `#### D604-D605: Borrow Terminator And Layout Discipline` at `kyokaidecided.md:9278-9294`.

Accepted-source SHA-256: `9752428064d080251e9bfdddbb85a6775be83df4fcdaded65685aaef7ce4d1dc`.

Destinations: `kyokaispec/src/toolchain/06-formatter.md`, `kyokaispec/src/toolchain/05-diagnostics.md`.

Proof impact: `NO_SEMANTIC_IMPACT`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D605.syntax-api` | `syntax-api` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D605.static` | `static` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D605.dynamic` | `dynamic` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D605.ownership` | `ownership` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D605.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D605.capability` | `capability` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D605.failure` | `failure` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D605.artifact` | `artifact` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D605.diagnostic` | `diagnostic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D605.compatibility` | `compatibility` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D605.target` | `target` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D605.example` | `example` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D605.illegal-form` | `illegal-form` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D605.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D606

Accepted source heading: `#### D606: Position-Bound Unsafe-Contract Labels` at `kyokaidecided.md:9295-9307`.

Accepted-source SHA-256: `ac3c2f4026733f20e265c6e04c3942016672c6e53d12209093cf2896a0f711e0`.

Destinations: `kyokaispec/src/language/02-lexical-syntax.md`, `kyokaispec/src/language/03-grammar.md`.

Proof impact: `MODEL_AFFECTING`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D606.syntax-api` | `syntax-api` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D606.static` | `static` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D606.dynamic` | `dynamic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D606.ownership` | `ownership` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D606.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D606.capability` | `capability` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D606.failure` | `failure` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D606.artifact` | `artifact` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D606.diagnostic` | `diagnostic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D606.compatibility` | `compatibility` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D606.target` | `target` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D606.example` | `example` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D606.illegal-form` | `illegal-form` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D606.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D607

Accepted source heading: `#### D607: Distinct Borrow Spellings` at `kyokaidecided.md:9308-9327`.

Accepted-source SHA-256: `54f41e93c806c80b4930ff7856c78cbdf9b850564af394e7c409ccbd94056e90`.

Destinations: `kyokaispec/src/language/02-lexical-syntax.md`, `kyokaispec/src/language/03-grammar.md`, `kyokaispec/src/language/11-linearity-borrowing-and-regions.md`, `kyokaispec/src/rationale/02-syntax.md`.

Proof impact: `MODEL_AFFECTING`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D607.syntax-api` | `syntax-api` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D607.static` | `static` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D607.dynamic` | `dynamic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D607.ownership` | `ownership` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D607.borrow` | `borrow` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D607.capability` | `capability` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D607.failure` | `failure` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D607.artifact` | `artifact` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D607.diagnostic` | `diagnostic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D607.compatibility` | `compatibility` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D607.target` | `target` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D607.example` | `example` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D607.illegal-form` | `illegal-form` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D607.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D608

Accepted source heading: `#### D608: Comment Syntax Reaffirmation` at `kyokaidecided.md:9328-9334`.

Accepted-source SHA-256: `d5a9615ba2c70fc5bde77074e689012e089998cd859c7cdc1f9f1f01d196c1a5`.

Destinations: `kyokaispec/src/language/02-lexical-syntax.md`, `kyokaispec/src/rationale/02-syntax.md`.

Proof impact: `MODEL_AFFECTING`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D608.syntax-api` | `syntax-api` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D608.static` | `static` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D608.dynamic` | `dynamic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D608.ownership` | `ownership` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D608.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D608.capability` | `capability` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D608.failure` | `failure` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D608.artifact` | `artifact` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D608.diagnostic` | `diagnostic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D608.compatibility` | `compatibility` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D608.target` | `target` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D608.example` | `example` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D608.illegal-form` | `illegal-form` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D608.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D609

State: `superseded` by `D585`.

D609 was withdrawn as a duplicate of D585's closed TextView formation rule.

## D610

Accepted source heading: `#### D610: `build;` And Branch-Local Production` at `kyokaidecided.md:9335-9347`.

Accepted-source SHA-256: `1a36a6aee220a1be039e0d6e956904003db3f8f404d8436ea0ffa4606652329c`.

Destinations: `kyokaispec/src/language/03-grammar.md`, `kyokaispec/src/language/09-expressions-and-evaluation.md`, `kyokaispec/src/language/10-statements-and-control-flow.md`.

Proof impact: `MODEL_AFFECTING`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D610.syntax-api` | `syntax-api` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D610.static` | `static` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D610.dynamic` | `dynamic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D610.ownership` | `ownership` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D610.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D610.capability` | `capability` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D610.failure` | `failure` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D610.artifact` | `artifact` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D610.diagnostic` | `diagnostic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D610.compatibility` | `compatibility` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D610.target` | `target` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D610.example` | `example` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D610.illegal-form` | `illegal-form` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D610.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D611

Accepted source heading: `#### D611: No-Shadowing Transformation Assistance` at `kyokaidecided.md:9348-9359`.

Accepted-source SHA-256: `62e95227b7dc8b9c5fcac8b5f63dc19a2eb48b52ba89a614ca4c0b51174a38f0`.

Destinations: `kyokaispec/src/toolchain/05-diagnostics.md`, `kyokaispec/src/toolchain/08-docs-lsp-audit.md`.

Proof impact: `NO_SEMANTIC_IMPACT`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D611.syntax-api` | `syntax-api` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D611.static` | `static` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D611.dynamic` | `dynamic` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D611.ownership` | `ownership` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D611.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D611.capability` | `capability` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D611.failure` | `failure` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D611.artifact` | `artifact` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D611.diagnostic` | `diagnostic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D611.compatibility` | `compatibility` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D611.target` | `target` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D611.example` | `example` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D611.illegal-form` | `illegal-form` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D611.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D612

Accepted source heading: `#### D612: Frontend Ownership And Migration Boundaries` at `kyokaidecided.md:9360-9376`.

Accepted-source SHA-256: `f03b88ead412fef1989c2b93dad50949c182efa1f910e5a6122940c51f563122`.

Destinations: `kyokaispec/src/toolchain/00-toolchain-overview.md`, `kyokaispec/src/language/17-memory-layout-and-backend-contract.md`.

Proof impact: `NO_SEMANTIC_IMPACT`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D612.syntax-api` | `syntax-api` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D612.static` | `static` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D612.dynamic` | `dynamic` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D612.ownership` | `ownership` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D612.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D612.capability` | `capability` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D612.failure` | `failure` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D612.artifact` | `artifact` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D612.diagnostic` | `diagnostic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D612.compatibility` | `compatibility` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D612.target` | `target` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D612.example` | `example` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D612.illegal-form` | `illegal-form` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D612.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D613

State: `superseded` by `D581`.

D613 was withdrawn as a duplicate of D581's revision-bound proof review rule.

## D614

Accepted source heading: `#### D614: Typed Finding Intake` at `kyokaidecided.md:9377-9391`.

Accepted-source SHA-256: `57be1706b623c4cd6114a2956fc8ebe5be16cde3111d09a1de58772a88598321`.

Destinations: `kyokaispec/src/project/01-governance.md`, `PROJECT_STANDARDS.md`, `phase.md`.

Proof impact: `NO_SEMANTIC_IMPACT`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D614.syntax-api` | `syntax-api` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D614.static` | `static` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D614.dynamic` | `dynamic` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D614.ownership` | `ownership` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D614.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D614.capability` | `capability` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D614.failure` | `failure` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D614.artifact` | `artifact` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D614.diagnostic` | `diagnostic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D614.compatibility` | `compatibility` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D614.target` | `target` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D614.example` | `example` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D614.illegal-form` | `illegal-form` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D614.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D615

Accepted source heading: `### D615: Bleedring Bootstrap Installation And Bundled Distribution` at `kyokaidecided.md:9401-9449`.

Accepted-source SHA-256: `c7083a32fcbf24e8fc82e64dc49df40320bfd1ac92261e5a3dda717bf76c0082`.

Destinations: `kyokaispec/src/toolchain/03-cli.md`, `kyokaispec/src/toolchain/04-build-profiles-targets-linking.md`, `kyokaispec/src/toolchain/10-package-index-semver-releases-ci.md`.

Proof impact: `MAPPING_ONLY`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D615.syntax-api` | `syntax-api` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D615.static` | `static` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D615.dynamic` | `dynamic` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D615.ownership` | `ownership` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D615.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D615.capability` | `capability` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D615.failure` | `failure` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D615.artifact` | `artifact` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D615.diagnostic` | `diagnostic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D615.compatibility` | `compatibility` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D615.target` | `target` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D615.example` | `example` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D615.illegal-form` | `illegal-form` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D615.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D616

Accepted source heading: `### D616: Named Deep-Analysis Engines` at `kyokaidecided.md:9450-9475`.

Accepted-source SHA-256: `926675c4ea4ab04dadfdea1c2990b8548908bc4b1f72b9c126aede685d2937ab`.

Destinations: `kyokaispec/src/toolchain/03-cli.md`, `kyokaispec/src/toolchain/05-diagnostics.md`, `kyokaispec/src/toolchain/07-testing-coverage-bench.md`, `kyokaispec/src/language/17-memory-layout-and-backend-contract.md`.

Proof impact: `MAPPING_ONLY`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D616.syntax-api` | `syntax-api` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D616.static` | `static` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D616.dynamic` | `dynamic` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D616.ownership` | `ownership` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D616.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D616.capability` | `capability` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D616.failure` | `failure` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D616.artifact` | `artifact` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D616.diagnostic` | `diagnostic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D616.compatibility` | `compatibility` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D616.target` | `target` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D616.example` | `example` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D616.illegal-form` | `illegal-form` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D616.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D617

State: `superseded` by `D527/D545/D590`.

D617 was withdrawn because it adds no rule beyond D527, D545, and D590.

## D618

Accepted source heading: `### D618: `kyokai dev` Supervision And Reload` at `kyokaidecided.md:9487-9526`.

Accepted-source SHA-256: `2aba5c329953530acdaa5880f92e70c491288b9ae1a11dd64820b37cfe073d56`.

Destinations: `kyokaispec/src/toolchain/03-cli.md`, `kyokaispec/src/toolchain/11-build-generation-and-playground.md`, `kyokaispec/src/language/14-capabilities-and-authority.md`.

Proof impact: `MAPPING_ONLY`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D618.syntax-api` | `syntax-api` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D618.static` | `static` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D618.dynamic` | `dynamic` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D618.ownership` | `ownership` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D618.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D618.capability` | `capability` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D618.failure` | `failure` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D618.artifact` | `artifact` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D618.diagnostic` | `diagnostic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D618.compatibility` | `compatibility` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D618.target` | `target` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D618.example` | `example` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D618.illegal-form` | `illegal-form` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D618.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D619

Accepted source heading: `### D619: Apple Support Is An Evidence Matrix` at `kyokaidecided.md:9527-9549`.

Accepted-source SHA-256: `f3ee61a80b3038449fba3c16513a413b4e6ae0b0549e74386edc6fdc0f5349c0`.

Destinations: `kyokaispec/src/toolchain/04-build-profiles-targets-linking.md`, `kyokaispec/src/toolchain/07-testing-coverage-bench.md`, `kyokaispec/src/toolchain/13-application-integration-and-deployment.md`.

Proof impact: `NO_SEMANTIC_IMPACT`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D619.syntax-api` | `syntax-api` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D619.static` | `static` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D619.dynamic` | `dynamic` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D619.ownership` | `ownership` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D619.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D619.capability` | `capability` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D619.failure` | `failure` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D619.artifact` | `artifact` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D619.diagnostic` | `diagnostic` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D619.compatibility` | `compatibility` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D619.target` | `target` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D619.example` | `example` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D619.illegal-form` | `illegal-form` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D619.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D620

Accepted source heading: `### D620: Game Reference Stacks Without An Official Engine` at `kyokaidecided.md:9550-9568`.

Accepted-source SHA-256: `3e3e9acfea037be6428f33aec1d2c5dc3affab8713805c9ab4a9dd383bb29983`.

Destinations: `kyokaispec/src/project/06-reference-products-and-workloads.md`, `kyokaispec/src/stdlib/12-application-integration-contracts.md`, `kyokaispec/src/toolchain/07-testing-coverage-bench.md`, `kyokaispec/src/toolchain/13-application-integration-and-deployment.md`.

Proof impact: `NO_SEMANTIC_IMPACT`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D620.syntax-api` | `syntax-api` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D620.static` | `static` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D620.dynamic` | `dynamic` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D620.ownership` | `ownership` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D620.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D620.capability` | `capability` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D620.failure` | `failure` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D620.artifact` | `artifact` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D620.diagnostic` | `diagnostic` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D620.compatibility` | `compatibility` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D620.target` | `target` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D620.example` | `example` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D620.illegal-form` | `illegal-form` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D620.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D621

Accepted source heading: `### D621: One Analysis Engine, Complete CLI And Machine Access` at `kyokaidecided.md:9569-9587`.

Accepted-source SHA-256: `423977c32fa44e3333ddee703255b806b599575de25e7024bbf5ab7383d9245d`.

Destinations: `kyokaispec/src/toolchain/03-cli.md`, `kyokaispec/src/toolchain/05-diagnostics.md`, `kyokaispec/src/toolchain/08-docs-lsp-audit.md`.

Proof impact: `MAPPING_ONLY`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D621.syntax-api` | `syntax-api` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D621.static` | `static` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D621.dynamic` | `dynamic` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D621.ownership` | `ownership` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D621.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D621.capability` | `capability` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D621.failure` | `failure` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D621.artifact` | `artifact` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D621.diagnostic` | `diagnostic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D621.compatibility` | `compatibility` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D621.target` | `target` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D621.example` | `example` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D621.illegal-form` | `illegal-form` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D621.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D622

State: `superseded` by `D531-D536/D569a-D569c`.

D622 was withdrawn because the generated-C evidence rule is already owned by D531-D536 and D569a-D569c.

## D623

Accepted source heading: `### D623: Cross-Phase Workload Evidence` at `kyokaidecided.md:9588-9610`.

Accepted-source SHA-256: `f1bc90b311ba39b2e07e828304b8bde870937ee9bd3d2f3ecc8d3974a7dd2f76`.

Destinations: `kyokaispec/src/project/06-reference-products-and-workloads.md`, `kyokaispec/src/toolchain/07-testing-coverage-bench.md`, `kyokaispec/src/language/19-examples.md`, `phase.md`.

Proof impact: `NO_SEMANTIC_IMPACT`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D623.syntax-api` | `syntax-api` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D623.static` | `static` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D623.dynamic` | `dynamic` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D623.ownership` | `ownership` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D623.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D623.capability` | `capability` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D623.failure` | `failure` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D623.artifact` | `artifact` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D623.diagnostic` | `diagnostic` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D623.compatibility` | `compatibility` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D623.target` | `target` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D623.example` | `example` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D623.illegal-form` | `illegal-form` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D623.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D624

Accepted source heading: `### D624: Foreign Build Plan Protocol` at `kyokaidecided.md:9611-9639`.

Accepted-source SHA-256: `ce5eafd5d5d3c567ff2170130117a3d27fa28a772de2d307f316c216980b8dba`.

Destinations: `kyokaispec/src/toolchain/04-build-profiles-targets-linking.md`, `kyokaispec/src/toolchain/11-build-generation-and-playground.md`, `kyokaispec/src/language/14-capabilities-and-authority.md`.

Proof impact: `MAPPING_ONLY`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D624.syntax-api` | `syntax-api` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D624.static` | `static` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D624.dynamic` | `dynamic` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D624.ownership` | `ownership` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D624.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D624.capability` | `capability` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D624.failure` | `failure` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D624.artifact` | `artifact` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D624.diagnostic` | `diagnostic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D624.compatibility` | `compatibility` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D624.target` | `target` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D624.example` | `example` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D624.illegal-form` | `illegal-form` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D624.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D624a

Accepted source heading: `### D624a: Workspace Packages, Individual Publication, And Published Knots` at `kyokaidecided.md:9640-9721`.

Accepted-source SHA-256: `0f8b50929d892929657e834ecc1188f08dbe8f43b56a4e82cca9b00c02bc0b7e`.

Destinations: `kyokaispec/src/toolchain/01-manifest-package-workspace.md`, `kyokaispec/src/toolchain/02-module-resolution-and-koi.md`, `kyokaispec/src/toolchain/03-cli.md`, `kyokaispec/src/toolchain/08-docs-lsp-audit.md`, `kyokaispec/src/toolchain/09-reproducibility-incremental-builds.md`, `kyokaispec/src/toolchain/10-package-index-semver-releases-ci.md`.

Proof impact: `MAPPING_ONLY`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D624a.syntax-api` | `syntax-api` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D624a.static` | `static` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D624a.dynamic` | `dynamic` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D624a.ownership` | `ownership` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D624a.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D624a.capability` | `capability` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D624a.failure` | `failure` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D624a.artifact` | `artifact` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D624a.diagnostic` | `diagnostic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D624a.compatibility` | `compatibility` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D624a.target` | `target` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D624a.example` | `example` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D624a.illegal-form` | `illegal-form` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D624a.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D625

Accepted source heading: `### D625: Stable-Carried Experiments` at `kyokaidecided.md:9722-9768`.

Accepted-source SHA-256: `5bea3145bd46f509aac09d4b09f27c913ed6ee9581490938d506ddb8aea08b60`.

Destinations: `PROJECT_STANDARDS.md`, `kyokaispec/src/toolchain/01-manifest-package-workspace.md`, `kyokaispec/src/toolchain/03-cli.md`, `kyokaispec/src/toolchain/07-testing-coverage-bench.md`, `kyokaispec/src/toolchain/10-package-index-semver-releases-ci.md`.

Proof impact: `NO_SEMANTIC_IMPACT`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D625.syntax-api` | `syntax-api` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D625.static` | `static` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D625.dynamic` | `dynamic` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D625.ownership` | `ownership` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D625.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D625.capability` | `capability` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D625.failure` | `failure` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D625.artifact` | `artifact` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D625.diagnostic` | `diagnostic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D625.compatibility` | `compatibility` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D625.target` | `target` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D625.example` | `example` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D625.illegal-form` | `illegal-form` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D625.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D626

State: `superseded` by `D596a`.

D626 was withdrawn by D596a; overarching Rust integration remains rejected.

## Maturity Result

Every required D558-D625 decision, including sub-decisions, is clause-complete or recorded as superseded. This batch satisfies D577's clause-evidence condition for `SPEC_EXTRACTED`. Together with the checked pre-D558 and D627-D635 registries, Gate A is closed through D635. This does not upgrade implementation, conformance, admission, service, workload, or proof state.
