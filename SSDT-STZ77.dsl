/*
 * Credits: Master Chief (dad) for his stripped down copy of Method _DSM and teaching us
 *          to code, and of course his inspiring talent to help other people for free.
 *
 *          RevoGirl (my late sister Samantha) for the first ever tiny SSDT, and her
 *          discovery of property 'hda-gfx' in her MacBook Pro (at a time that the hardware
 *          wasn't even released).
 *
 *          Pike for stripping method _DSM even further and finding a way to disable/hide
 *          devices in the DSDT, including ThermalZones. Something that was impossible until now.
 */

 /*
 * Originally for Gigabyte Z87MX-D3H, adapted to work with Asus STZ77, incl. PJALM patch.
 */

DefinitionBlock ("SSDT-STZ77.aml", "SSDT", 1, "APPLE", "tinySSDT", 0x00000006)
{
    External (\IOST, IntObj)

    External (\_SB_.PCI0, DeviceObj)
    //External (\_SB_.WCAM, DeviceObj)
    External (\AMW0, DeviceObj)

    External (\_SB_.LNKA._STA, IntObj)
    External (\_SB_.LNKB._STA, IntObj)
    External (\_SB_.LNKC._STA, IntObj)
    External (\_SB_.LNKD._STA, IntObj)
    External (\_SB_.LNKE._STA, IntObj)
    External (\_SB_.LNKF._STA, IntObj)
    External (\_SB_.LNKG._STA, IntObj)
    External (\_SB_.LNKH._STA, IntObj)

    External (\_SB_.PCI0.PEG0, DeviceObj)
    External (\_SB_.PCI0.PEG0.PEGP, DeviceObj)
    External (\_SB_.PCI0.PEG0.HRU4, DeviceObj)
    External (\_SB_.PCI0.PEG1.HRU4, DeviceObj)
    External (\_SB_.PCI0.PEG2.HRU4, DeviceObj)
    External (\_SB_.PCI0.RP01.HRU4, DeviceObj)
    External (\_SB_.PCI0.EHC1, DeviceObj)
    External (\_SB_.PCI0.EHC2, DeviceObj)
    External (\_SB_.PCI0.XHC, DeviceObj)
    External (\_SB_.PCI0.GLAN, DeviceObj)
    //External (\_SB_.PCI0.SBUS.BUS0, DeviceObj)
    //External (\_SB_.PCI0.B0D3._STA, IntObj)
    External (\_SB_.PCI0.B0D4, DeviceObj)
    External (\_SB_.PCI0.GFX0, DeviceObj)
    External (\_SB_.PCI0.HDEF, DeviceObj)
    External (\_SB_.PCI0.LPCB, DeviceObj)
    External (\_SB_.PCI0.LPCB.SIO1, DeviceObj)
    //External (\_SB_.PCI0.RP05, DeviceObj)
    //External (\_SB_.PCI0.RP05.PXSX, DeviceObj)
    External (\_SB_.PCI0.SAT0, DeviceObj)
    External (\_SB_.PCI0.SAT1, DeviceObj)
    External (\_SB_.PCI0.TPMX._STA, DeviceObj)
    External (\_SB_.PCI0.WMI1, DeviceObj)

    External (\_TZ_.FAN0, DeviceObj)
    External (\_TZ_.FAN1, DeviceObj)
    External (\_TZ_.FAN2, DeviceObj)
    External (\_TZ_.FAN3, DeviceObj)
    External (\_TZ_.FAN4, DeviceObj)

    External (\_TZ_.TZ00, PkgObj)
    External (\_TZ_.TZ01, PkgObj)

    Scope (\)
    {

        Scope (AMW0)
        {
            Name (_STA, Zero)
        }

        Scope (\_SB_)
        {
            Method (_INI, 0, NotSerialized)
            {
                /* Here we disable/hide Devices (LNKx) */

                Store (Zero, \_SB_.LNKA._STA)
                Store (Zero, \_SB_.LNKB._STA)
                Store (Zero, \_SB_.LNKC._STA)
                Store (Zero, \_SB_.LNKD._STA)
                Store (Zero, \_SB_.LNKE._STA)
                Store (Zero, \_SB_.LNKF._STA)
                Store (Zero, \_SB_.LNKG._STA)
                Store (Zero, \_SB_.LNKH._STA)

                /* Here we disable/hide Devices (B0D3)

                Store (Zero, \_SB_.PCI0.B0D3._STA)
                */

                /* Here we disable/hide Devices (TMPX) */

                Store (Zero, \_SB_.PCI0.TPMX._STA)

                /* Here we disable/hide Devices (PS2x) */

                Store (Zero, \IOST)

                /* Here we disable/hide ThermalZone (TZ0n) */

                Store (Zero, \_TZ_.TZ00)
                Store (Zero, \_TZ_.TZ01)
            }

            /* Here we disable/hide Device WCAM

            Scope (WCAM)
            {
                Name (_STA, Zero)
            }
            */

            Device (PNLF)
            {
                Name (_ADR, 0x00)
                Name (_HID, EisaId ("APP0002"))
                Name (_CID, "backlight")
                Name (_UID, 0x0A)
                Name (_STA, 0x0B)
/*
                Method (_DSM, 4, NotSerialized)
                {
                    If (LEqual (Arg2, Zero))
                    {
                        Return (Buffer (One)
                        {
                            0x03
                        })
                    }

                    Return (Package (0x02)
                    {
                        "refnum",
                        0x00,
                        "type",
                        BLCT
                    })
                }
*/
            }
        }

        Scope (\_SB_.PCI0)
        {
            /* Here we inject a new Device MCHC */

            Device (MCHC)
            {
                Name (_ADR, Zero)
            }

            /* Here we inject a new Device HECI / MEI */

            Device (HECI)
            {
                Name (_ADR, 0x00160000)
            }

            /* Here we disable/hide Device GFX0 */

            Scope (GFX0)
            {
                Name (_STA, Zero)
            }

            /* Here we inject a new Device IGPU */

            Device (IGPU)
            {
                Name (_ADR, 0x00020000) // _ADR: Address

                Method (_DSM, 4, NotSerialized)
                {
                    If (LEqual (Arg2, Zero))
                    {
                        Return (Buffer (One)
                        {
                            0x03
                        })
                    }

                    Return (Package (0x02)
                    {
                        "hda-gfx",
                        Buffer (0x0A)
                        {
                            "onboard-1"
                        }
                    })
                }
            }

            /* Here we inject a new Device HDAU

            Device (HDAU)
            {
                Name (_ADR, 0x00030000)
                Name (_STA, 0x0F) // _STA: Status

                OperationRegion (HDAH, PCI_Config, 0x54, One)
                Field (HDAH, ByteAcc, NoLock, Preserve)
                {
                        ,   5,
                    AUDE,   1
                }

                Method (_INI, 0, NotSerialized)
                {
                    Store (One, AUDE)
                    Notify (PCI0, Zero)
                }

                // Here we inject a new Method _DSM

                Method (_DSM, 4, NotSerialized)
                {
                    If (LEqual (Arg2, Zero))
                    {
                        Return (Buffer (One)
                        {
                            0x03
                        })
                    }

                    Return (Package (0x02)
                    {
                        "hda-gfx",
                        Buffer (0x0A)
                        {
                            "onboard-1"
                        }
                    })
                }
            }
            */

            Scope (PEG0)
            {
                // Disable PEGP to overide with GFX0
                Scope (PEGP)
                {
                    Name (_STA, Zero)
                }

                // Disable unknown HRU4 devices
                Scope (HRU4)
                {
                    Name (_STA, Zero)
                }

                Device (GFX0)
                {
                    Name (_ADR, Zero)
                    //Name (_SUN, One)        // Avoid kernel: System sleep prevented by GFX0

                    Method (_DSM, 4, NotSerialized)
                    {
                        If (LEqual (Arg2, Zero))
                        {
                            Return (Buffer (One)
                            {
                                0x03
                            })
                        }

                        Return (Package (0x02)
                        {
                            "hda-gfx",
                            Buffer (0x0A)
                            {
                                "onboard-2"
                            }
                        })
                    }
                }

                Device (HDAU)
                {
                    Name (_ADR, One)

                    Method (_DSM, 4, NotSerialized)
                    {
                        If (LEqual (Arg2, Zero))
                        {
                            Return (Buffer (One)
                            {
                                0x03
                            })
                        }

                        Return (Package (0x02)
                        {
                            "hda-gfx",
                            Buffer (0x0A)
                            {
                                "onboard-2"
                            }
                        })
                    }
                }
            }

            // Disable unknown HRU4 devices
            Scope (\_SB_.PCI0.PEG1.HRU4)
            {
                Name (_STA, Zero)
            }

            // Disable unknown HRU4 devices
            Scope (\_SB_.PCI0.PEG2.HRU4)
            {
                Name (_STA, Zero)
            }

            // Disable unknown HRU4 devices
            Scope (\_SB_.PCI0.RP01.HRU4)
            {
                Name (_STA, Zero)
            }

            /* Here we disable/hide Device B0D4 */

            Scope (B0D4)
            {
                Name (_STA, Zero)
            }

            /* Here we add (audio related) properties to Device HDEF */

            Scope (HDEF)
            {
                /* Here we inject a new Method _DSM */

                Method (_DSM, 4, NotSerialized)
                {
                    If (LEqual (Arg2, Zero))
                    {
                        Return (Buffer (One)
                        {
                            0x03
                        })
                    }

                    Return (Package (0x06)
                    {
                        "layout-id",
                        Buffer (0x04)
                        {
                            0x03, 0x00, 0x00, 0x00
                        },

                        "PinConfigurations",
                        Buffer (Zero) {},

                        "hda-gfx",
                        Buffer (0x0A)
                        {
                            "onboard-1"
                        }
                    })
                }
            }

            Scope (LPCB)
            {
                /* Here we disable/hide Device SIO1 */

                Scope (SIO1)
                {
                    Name (_STA, Zero)
                }
            }

            /* RP05 is used for my Wifi/Bluetooth 4.0 card, installed in slot 'PCIEX4'

            Scope (RP05)
            {
                // Here we disable/hide Device PSXS

                Scope (PXSX)
                {
                    Name (_STA, Zero)
                }

                // Here we inject a new Device ARPT

                Device (ARPT)
                {
                    Name (_ADR, Zero)
                    Name (_PRW, Package (0x02)
                    {
                        0x09,
                        0x04
                    })
                }
            }

            */

            /* Here we disable/hide Device SAT0 */

            Scope (SAT0)
            {
                Name (_STA, Zero)
            }

            /* Here we disable/hide Device SAT1 */

            Scope (SAT1)
            {
                Name (_STA, Zero)
            }

            /* Here we inject a new Device SATA */

            Device (SATA)
            {
                Name (_ADR, 0x001F0002)
            }

            /* Here we disable/hide Device WMI1 */

            Scope (WMI1)
            {
                Name (_STA, Zero)
            }

            Device (\_SB_.PCI0.SBUS.BUS0)
            {
                Name (_CID, "smbus")
                Name (_ADR, Zero)
                Device (DVL0)
                {
                    Name (_ADR, 0x57)
                    Name (_CID, "diagsvault")

                    Method (_DSM, 4, NotSerialized)
                    {
                        If (LEqual (Arg2, Zero))
                        {
                            Return (Buffer (One)
                            {
                                0x03
                            })
                        }

                        Return (Package (0x02)
                        {
                            "address",
                            0x57
                        })
                    }
                }
            }

            Scope (EHC1)
            {
                Method (_DSM, 4, NotSerialized)
                {
                    If (LEqual (Arg2, Zero))
                    {
                        Return (Buffer (One)
                        {
                            0x03
                        })
                    }

                    Return (Package (0x0D)
                    {
                        "AAPL,current-available", 0x0834,
                        "AAPL,current-extra", 0x0A8C,
                        "AAPL,current-in-sleep", 0x03E8,
                        "AAPL,current-extra-in-sleep", 0x0834,
                        "AAPL,max-port-current-in-sleep", 0x0A8C,
                        "AAPL,device-internal", 0x02,
                        Buffer (One) {0x00}
                    })
                }
            }

            Scope (EHC2)
            {
                Method (_DSM, 4, NotSerialized)
                {
                    If (LEqual (Arg2, Zero))
                    {
                        Return (Buffer (One)
                        {
                            0x03
                        })
                    }

                    Return (Package (0x0D)
                    {
                        "AAPL,current-available", 0x0834,
                        "AAPL,current-extra", 0x0A8C,
                        "AAPL,current-in-sleep", 0x03E8,
                        "AAPL,current-extra-in-sleep", 0x0834,
                        "AAPL,max-port-current-in-sleep", 0x0A8C,
                        "AAPL,device-internal", 0x02,
                        Buffer (One) {0x00}
                    })
                }
            }

            Scope (XHC)
            {
                Method (_DSM, 4, NotSerialized)
                {
                    If (LEqual (Arg2, Zero))
                    {
                        Return (Buffer (One)
                        {
                            0x03
                        })
                    }

                    Return (Package (0x0D)
                    {
                        "AAPL,current-available", 0x0834,
                        "AAPL,current-extra", 0x0A8C,
                        "AAPL,current-in-sleep", 0x03E8,
                        "AAPL,current-extra-in-sleep", 0x0834,
                        "AAPL,max-port-current-in-sleep", 0x0A8C,
                        "AAPL,device-internal", 0x02,
                        Buffer (One) {0x00}
                    })
                }
            }

            Scope (GLAN)
            {
                Method (_DSM, 4, NotSerialized)
                {
                    If (LEqual (Arg2, Zero))
                    {
                        Return (Buffer (One)
                        {
                            0x03
                        })
                    }

                    Return (Package (0x04)
                    {
                        "built-in", Buffer (One) {0x01},
                        "location", Buffer (One) {"1"}
                    })
                }
            }
        }

        Scope (\_TZ_)
        {
            /* Here we disable/hide Device FAN0 */

            Scope (FAN0)
            {
                Name (_STA, Zero)
            }

            /* Here we disable/hide Device FAN1 */

            Scope (FAN1)
            {
                Name (_STA, Zero)
            }

            /* Here we disable/hide Device FAN2 */

            Scope (FAN2)
            {
                Name (_STA, Zero)
            }

            /* Here we disable/hide Device FAN3 */

            Scope (FAN3)
            {
                Name (_STA, Zero)
            }

            /* Here we disable/hide Device FAN4 */

            Scope (FAN4)
            {
                Name (_STA, Zero)
            }
        }
    }
}

