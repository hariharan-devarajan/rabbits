# Result from Testing Rabbits

## FPP with Write-Only

### Default case with no control on rabbit nodes. with fsync

| Nodes    | PPN     | Operation | Logs                                         |
| -------- | ------- | --------- | -------------------------------------------- |
| 1        | 1       | WO FPP    | [link](benchmarks/ior/output/xfs/ior-20241014182525) |
| 1        | 2       | WO FPP    | [link](benchmarks/ior/output/xfs/ior-20241014184458) |
| 1        | 4       | WO FPP    | [link](benchmarks/ior/output/xfs/ior-20241014184928) |
| 1        | 8       | WO FPP    | [link](benchmarks/ior/output/xfs/ior-20241014185601) |
| 1        | 16      | WO FPP    | [link](benchmarks/ior/output/xfs/ior-20241014190055) |
| 1        | 32      | WO FPP    | [link](benchmarks/ior/output/xfs/ior-20241014190713) |
| 1        | 64      | WO FPP    | [link](benchmarks/ior/output/xfs/ior-20241014191819) |
| 2        | 64      | WO FPP    | [link](benchmarks/ior/output/xfs/ior-20241014194044) |
| 4        | 64      | WO FPP    | [link](benchmarks/ior/output/xfs/ior-20241014200912) |
| 8        | 64      | WO FPP    | [link](benchmarks/ior/output/xfs/ior-20241014204803) |
| 16       | 64      | WO FPP    | [link](benchmarks/ior/output/xfs/ior-20241014225041) |

###  1 rabbit node scaling with fsync


| 1        | 64      | WO FPP    | [link](benchmarks/ior/output/xfs/ior-20241014191819) |
| 2        | 64      | WO FPP    | [link]() |
| 4        | 64      | WO FPP    | [link]() |
| 8        | 64      | WO FPP    | [link]() |
| 16       | 64      | WO FPP    | [link]() |


###  1 rabbit node scaling no sync

benchmarks/ior/output/xfs/ior-20241015131434
| 1        | 64      | WO FPP    | [link]() |
| 2        | 64      | WO FPP    | [link]() |
| 4        | 64      | WO FPP    | [link]() |
| 8        | 64      | WO FPP    | [link]() |
| 16       | 64      | WO FPP    | [link]() |

benchmarks/ior/output/xfs/ior-20241015130504
| 1        | 96      | WO FPP    | [link]() |
| 2        | 96      | WO FPP    | [link]() |
| 4        | 96      | WO FPP    | [link]() |
| 8        | 96      | WO FPP    | [link]() |
| 16       | 96      | WO FPP    | [link]() |

### Rabbit interference.