---
title: "Beelink SER8 — Datasheet"
---
{% raw %}

> Hardware only. Operating systems installed on this machine: [Operating Systems](../../operating_systems.md) · fleet: [Machine Fleet](../../machine_fleet.md).

## Overview
The Beelink SER8 is a compact mini PC (0.814 L, 0.75 kg) built around the AMD Ryzen 7 8745HS (8C/16T, Radeon 780M iGPU) — Beelink describes it as equivalent to the 8845HS without the Ryzen AI NPU. It uses the MSC 2.0 cooling system (vapor chamber, silent fan, SSD heatsink) rated at 32 dB, a metal case with a dustproof bottom filter, and no top or side vents. It supports up to 3 displays at 4K (HDMI 2.1 4K@120 Hz, DP 1.4 4K@144 Hz, USB4 40 Gbps with DP 1.4/PD), 2.5 GbE LAN, Wi-Fi 6 and Bluetooth 5.2, 2 × DDR5-5600 SO-DIMM slots and 2 × M.2 2280 PCIe 4.0 x4 slots (up to 8 TB). Power adapter: 19 V / 5.26 A. Warranty: 3 years.
Product page: [Beelink SER8 8745HS — Beelink EU](https://eu.bee-link.com/products/beelink-ser8-8745hs)

> Differences between the product page and this unit: Beelink lists Intel AX210 Wi-Fi, this unit has an **AX200**; the page states 65 W TDP, this unit runs at a **54 W** power limit.
> Values marked *(load)* were captured while the CPU was under full load (snapshot 2026-09-29).

## System

| Item | Value |
|---|---|
| Manufacturer (DMI) | AZW (Beelink) |
| Model / family | SER8 |
| Chassis type | Mini PC |
| Baseboard | AZW SER8, rev. V10 |
| System serial | [REDACTED] |
| Baseboard serial | [REDACTED] |
| System UUID | [REDACTED] |
| SKU | 75 |
| Hostname | [REDACTED] |

## Firmware

| Item | Value |
|---|---|
| BIOS vendor | American Megatrends International (AMI, OEM ID `ALASKA`) |
| BIOS version | HPT.8xxx.SER8.V035.P8C0M0C15.14.Link |
| BIOS date | 2025-06-26 |
| BIOS ROM size | 16 MB |
| UEFI | Yes |
| SMBIOS | 3.5 |
| AMD AGESA | PhoenixPI-FP8-FP7 1.2.0.0c |
| SMU version | 76.96.00 |
| VBIOS | ATOMBIOS 022.012.000.028.000001, `113-PHXGENERIC-001` (PHOENIX, DDR5), built 2024-12-10, 16,896 bytes |

## CPU

| Item | Value |
|---|---|
| Model | AMD Ryzen 7 8745HS w/ Radeon 780M Graphics |
| Codename / package | Hawk Point / Socket FP7 |
| Process | 4 nm |
| Cores / threads | 8 / 16 (1 CCD, 1 CCX) |
| Base clock | 3.8 GHz (38×) |
| Max boost | 4.95 GHz (DMI) — observed 4.44 GHz all-core *(load)* |
| Preferred cores | #5, #7 |
| CPUID / stepping | F.5.2 / ext. 19.75 / HPT1-A2 |
| Microcode | 0xA70520A |
| L1 D / L1 I | 8 × 32 KB / 8 × 32 KB (8-way) |
| L2 | 8 × 1 MB (8-way) |
| L3 | 16 MB shared (16-way) |
| Instruction sets | MMX, SSE–SSE4.2, SSE4A, x86-64, AES, AVX, AVX2, AVX-512 (DQ, BW, VL, CD, IFMA, VBMI, VBMI2, VNNI, BITALG, VPOPCNTDQ, BF16), FMA3, SHA |
| P-states | 38× @ 1.194 V · 22× @ 1.069 V · 16× @ 0.944 V |
| Power limits | PL1 = PL2 = PPT = **54 W** |
| Tjmax | 90 °C |
| Measured *(load)* | 53.5 W package, 83 °C package, ~6.8 W per core |
| NPU | Not detected by CPU-Z (Ryzen AI NPU not listed) |

## Memory

| Item | Value |
|---|---|
| Installed | **32 GB** DDR5 (2 × 16 GB SO-DIMM) |
| Max supported (DMI) | 64 GB, 2 slots |
| Module | Micron/Crucial **CT16G56C46S5.M8D1**, single rank, 1.10 V, mfg. week 49/2024 |
| Module serials | [REDACTED], [REDACTED] |
| Speed | DDR5-5600 (2793.9 MHz), dual channel (4 × 32-bit sub-channels) |
| Timings | 46-45-45-90, tRC 135 (JEDEC, no XMP/EXPO profile) |
| ECC | None |
| PMIC | Monolithic Power Systems |

## Graphics

| Item | Value |
|---|---|
| iGPU | AMD Radeon 780M (RDNA 3), PCI ID 1002:1900 rev. B3 |
| Shader cores / ROPs | 768 / 16 |
| Dedicated (UMA) memory | 4 GB |
| Link | PCIe 4.0 x16 (internal) |
| Connected monitor | LG HDR 4K 27" (GSM7706), 3840 × 2160 @ 60 Hz |

## Storage

| Slot | Drive | Capacity | Link | Firmware | Serial |
|---|---|---|---|---|---|
| NVMe #0 (bus 1) | Crucial P3 Plus **CT4000P3PSSD8** M.2 2280 | 4 TB (3726 GiB) | PCIe 4.0 x4 | P9CR40D | [REDACTED] |
| NVMe #1 (bus 5) | Crucial P3 Plus **CT4000P3PSSD8** M.2 2280 | 4 TB (3726 GiB) | PCIe 4.0 x4 | P9CR40D | [REDACTED] |

Total raw storage: **8 TB**. Multiboot: each drive hosts one operating system — see [Operating Systems](../../operating_systems.md).

### SMART health (decoded from CPU-Z dump)

| Attribute | NVMe #0 | NVMe #1 |
|---|---|---|
| Temperature | 32 °C (sensor 2: 36 °C) | 32 °C (sensor 2: 36 °C) |
| Available spare | 100 % | 100 % |
| Percentage used | 0 % | 0 % |
| Data read | 1.22 TB | 1.86 TB |
| Data written | 1.55 TB | 3.54 TB |
| Power-on hours | 1,280 h | 1,278 h |
| Power cycles | 166 | 166 |
| Unsafe shutdowns | 33 | 93 |
| Media errors | 0 | 0 |

### CrystalDiskMark 9.0.3 — NVMe #0 (1 GiB × 3, drive 12 % full, 2026-09-29)

| Test | Read (MB/s) | Write (MB/s) |
|---|---|---|
| SEQ 1MiB Q8T1 | 5,039 | 4,432 |
| SEQ 1MiB Q1T1 | 2,832 | 4,346 |
| RND 4KiB Q32T1 | 601 (146.7k IOPS) | 431 (105.3k IOPS) |
| RND 4KiB Q1T1 | 50.6 (12.4k IOPS) | 217.6 (53.1k IOPS) |

## Networking

| Interface | Chip | Notes |
|---|---|---|
| Ethernet | Realtek **RTL8125** (10EC:8125) | 2.5 GbE, RJ-45 |
| Wi-Fi | Intel **Wi-Fi 6 AX200** (8086:2723) | 802.11ax, 160 MHz |
| Bluetooth | Intel Wireless Bluetooth (8087:0029) | integrated in AX200 |

## Chipset & expansion

| Item | Value |
|---|---|
| Northbridge / southbridge | AMD Ryzen SoC rev. 00 / AMD FCH rev. 51 |
| Bus | PCI Express 4.0 (16 GT/s) |
| Super I/O (LPCIO) | ITE IT8613 (HW monitor: ITE IT8625) |
| Security processor | AMD encryption device (1022:15C7) |
| USB controllers | 4 × AMD xHCI (15B9, 15BA, 15C0, 15C1) + 1 × AMD USB4 controller (1668) |
| Audio | AMD HD Audio (HDMI/DP, 1002:1640) + AMD HD Audio (1022:15E3) + AMD ACP (15E2) |
| M.2 slots (DMI) | J103 populated, J91 populated, U93 populated, J98 empty |
| PCIe slot (DMI) | J97 — not populated |

## External ports (as reported by DMI)

| Port | Type |
|---|---|
| USB Port 5 | USB 3.1 Type-A |
| USB Port 0, 1, 4 | USB 3.2 Type-C |
| Network | RJ-45 |
| Video | DP (NOVA DP), eDP (internal) |
| Audio | Microphone mini-jack, headphone mini-jack |

> DMI port tables are often incomplete on mini PCs: check the physical chassis for the full port list (HDMI, extra USB-A, USB4).

## Thermal & sensors *(load)*

| Sensor | Value |
|---|---|
| CPU package | 83 °C |
| TMPIN1 / TMPIN2 | 63 °C / 40 °C |
| Fan 1 | 1,896 RPM |
| CPU VCORE (ITE) | 0.68 V |

## Connected USB peripherals

| VID:PID | Device |
|---|---|
| 045E:0745 | Microsoft USB composite device (wireless receiver) |
| 045E:00E1 | Microsoft USB input device |
| 2DC8:301C | 8BitDo USB input device (controller) |
| 8087:0029 | Intel Bluetooth (internal) |

## Firmware updates & support

| Item | Source | Installed / notes |
|---|---|---|
| BIOS | Beelink — [October 2025 BIOS summary](https://www.bee-link.com/blogs/all/beelink-october-bios-update-summary) · [SER8 chipset compatibility notice](https://www.bee-link.com/de/blogs/all/ser8-chipset-driver-compatibility-notice-1) | Installed: **V035…C15.14** (2025-06-26). Latest: **V035.P8C0M0C15.16** (2026-06-03) → [download](https://url.bee-link.cn/FKyc) · [guide](https://url.bee-link.cn/5vkW). Cross-platform 15.14 flasher (Windows + Linux): [download](https://url.bee-link.cn/wwyn) · [guide](https://url.bee-link.cn/OQII) |
| NVMe firmware (Crucial P3 Plus) | [Crucial Storage Executive](https://www.crucial.com/support/storage-executive) | Installed: P9CR40D (both drives) |
| Beelink download center | [SER8-8745 folder — dr.bee-link.cn](https://dr.bee-link.cn/?dir=uploads%2FSER%2FSER8-8745) | BIOS, driver packs, factory image (`FW/SWS.rar`, 9.2 GB, not archived) |
| Support | [support-pc@bee-link.com](mailto:support-pc@bee-link.com) | 3-year warranty |

> **BIOS 15.16** fixes a chipset driver conflict (crashes, stutter, random restarts after OS or AMD driver updates). Flash it before installing new AMD drivers. Connect the PC to stable power while flashing.

### Local firmware archive (`DRIVERS/BIOS`)

| Item | Version | Local file | Size |
|---|---|---|---|
| BIOS | V035.P8C0M0C15.16 (2026-06-03) | [HPT_8xxx_SER8_V035_P8C0M0C15_16_BL_20260603.tar](https://dr.bee-link.cn/?dir=uploads%2FSER%2FSER8-8745) | 33.5 MB |
| BIOS flash guide (USB) | 15.16 | [SER8-V035_P8C0M0C15_16-Solve-Chipset-driver-compatibility-issue-Use-USB-to-flash-BIOS.pdf](https://dr.bee-link.cn/?dir=uploads%2FSER%2FSER8-8745) | 346 KB |

> OS drivers (`DRIVERS/DRIVER`, graphics package) are documented in each operating system's handbook — see [Operating Systems](../../operating_systems.md).

{% endraw %}
