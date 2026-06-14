# Backend Preservation Boundary

**Status:** `intended-by-spec` preservation plan  
**Layer:** `lambda_K-backend`

`lambda_K-seq` does not prove generated C or an external C compiler correct. Backend work must
preserve checked Kyokai semantics through explicit lowering obligations.

| Obligation | Required preservation rule |
| --- | --- |
| Evaluation order | Generated code preserves deterministic left-to-right Kyokai evaluation. |
| Checked arithmetic | Overflow, invalid shifts, division by zero, and bounds failure preserve Kyokai TPOE behavior without C undefined behavior or unsupported compiler assumptions. |
| Movement | Result placement and move elision preserve as-if movement and never duplicate a linear value. |
| Layout | Records, unions, packed data, extern records, tags, alignment, endian transforms, and ABI classes use named target facts. |
| Pointer behavior | Lowering avoids invalid aliasing, provenance violations, and unchecked pointer traps for safe programs. |
| Fatal paths | Stack overflow and synchronous host faults terminate before safe invariants are corrupted. |
| Diagnostics | Source spans, debug mapping, stripping, and generated-C inspection remain defined toolchain contracts. |

The preservation chain is:

```text
surface Kyokai
  -> explicit elaboration
  -> checked typed IR
  -> monomorphic IR
  -> generated-C backend
  -> admitted C compiler/linker contract
  -> target object and link step
```

Each arrow needs implementation evidence and conformance tests before it can
be labeled beyond `intended-by-spec`.
