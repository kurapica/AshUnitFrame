--========================================================--
--                Aim Default Skin                        --
--                                                        --
-- Author      :  kurapica125@outlook.com                 --
-- Create Date :  2020/12/11                              --
--========================================================--

--========================================================--
Scorpio           "AshUnitFrame.Skin.Default"        "1.0.0"
--========================================================--

namespace "AshUnitFrame"

-----------------------------------------------------------
-- SHARE SETTINGS
-----------------------------------------------------------
BORDER_SIZE                     = 1
BAR_HEIGHT                      = 3
ICON_BORDER_SIZE                = 1

CLASSICFICATION_ELITE           = {
    elite                       = true,
    rare                        = true,
    rareelite                   = true,
    worldboss                   = true,
}

CASTBAR_NORMAL_COLOR            = Color.WHITE
CASTBAR_NONINTERRUPTIBLE_COLOR  = Color.DEATHKNIGHT

SHARE_STATUSBAR_SKIN            = {
    statusBarTexture            = {
        file                    = [[Interface\Buttons\WHITE8x8]]
    },
    backgroundFrame             = {
        frameStrata             = "BACKGROUND",
        location                = { Anchor("TOPLEFT", -BORDER_SIZE, BORDER_SIZE), Anchor("BOTTOMRIGHT", BORDER_SIZE, -BORDER_SIZE) },
        backgroundTexture       = {
            drawLayer           = "BACKGROUND",
            setAllPoints        = true,
            color               = Color(0.2, 0.2, 0.2, 0.8),
        },
        backdrop                = {
            edgeFile            = [[Interface\Buttons\WHITE8x8]],
            edgeSize            = BORDER_SIZE,
        },

        backdropBorderColor     = Color.BLACK,
    },
}

AURA_PANEL_PLAYER_LOCATION      = { Anchor("BOTTOM", 0, 8, "HealthBar", "TOP") }
AURA_PANEL_NON_PLAYER_LOCATION  = { Anchor("BOTTOM", 0, 4, "NameLabel", "TOP") }

AURA_PANEL_ICON_DEBUFF_COLOR    = {
    ["none"]                    = Color(0.80, 0, 0),
    ["Magic"]                   = Color.MAGIC,
    ["Curse"]                   = Color.CURSE,
    ["Disease"]                 = Color.DISEASE,
    ["Poison"]                  = Color.POISON,
    [""]                        = DebuffTypeColor["none"],
}

-----------------------------------------------------------
-- Default Indicator and Style settings
-----------------------------------------------------------
Style.UpdateSkin("Default",     {
    -- Widget Template
    [ClassPowerBarElement]      = {
        SHARE_STATUSBAR_SKIN,

        autoHide                = false,
        autoFullValue           = true,
        statusBarColor          = Wow.ClassPowerColor(),
        backgroundFrame         = {
            backdropBorderColor = Wow.FromUIProperty("Activated"):Map(function(val) return val and Color.WHITE or Color.BLACK end),
        },
    },
    [AshAuraPanelIcon]          = {
        backdrop                = {
            edgeFile            = [[Interface\Buttons\WHITE8x8]],
            edgeSize            = BORDER_SIZE,
        },
        backdropBorderColor     = Wow.FromPanelProperty("AuraDebuff"):Map(function(dtype) return AURA_PANEL_ICON_DEBUFF_COLOR[dtype] or Color.WHITE end),

        -- Aura Icon
        IconTexture             = {
            drawLayer           = "BORDER",
            location            = { Anchor("TOPLEFT", BORDER_SIZE, -BORDER_SIZE), Anchor("BOTTOMRIGHT", -BORDER_SIZE, BORDER_SIZE) },
            file                = Wow.FromPanelProperty("AuraIcon"),
            texCoords           = RectType(0.1, 0.9, 0.1, 0.9),
        },

        -- Aura Count
        Label                   = {
            drawLayer           = "OVERLAY",
            fontObject          = NumberFontNormal,
            location            = { Anchor("CENTER", 0, 0, nil, "BOTTOMRIGHT") },
            text                = Wow.FromPanelProperty("AuraCount"):Map(function(val) return val and val > 1 and val or "" end),
        },

        -- Stealable
        MiddleBGTexture         = {
            drawLayer           = "OVERLAY",
            file                = [[Interface\TargetingFrame\UI-TargetingFrame-Stealable]],
            alphaMode           = "ADD",
            location            = { Anchor("TOPLEFT", -BORDER_SIZE, BORDER_SIZE), Anchor("BOTTOMRIGHT", BORDER_SIZE, -BORDER_SIZE) },
            visible             = Wow.FromPanelProperty("AuraStealable"),
        },

        -- Duration
        CooldownLabel           = {
            fontObject          = NumberFontNormal,
            cooldown            = Wow.FromPanelProperty("AuraCooldown"),
        },
    },
    [AshTotemPanelIcon]         = {
        backdrop                = {
            edgeFile            = [[Interface\Buttons\WHITE8x8]],
            edgeSize            = BORDER_SIZE,
        },
        backdropBorderColor     = Color.WHITE,

        -- Aura Icon
        IconTexture             = {
            drawLayer           = "BORDER",
            location            = { Anchor("TOPLEFT", BORDER_SIZE, -BORDER_SIZE), Anchor("BOTTOMRIGHT", -BORDER_SIZE, BORDER_SIZE) },
            file                = Wow.FromPanelProperty("TotemIcon"),
            texCoords           = RectType(0.1, 0.9, 0.1, 0.9),
        },

        -- Duration
        CooldownLabel           = {
            fontObject          = NumberFontNormal,
            cooldown            = Wow.FromPanelProperty("TotemCooldown"),
        },
    },
    [ClassPowerBar]             = {
        frameStrata             = "LOW",
        enableMouse             = false,

        columnCount             = 8,
        rowCount                = 1,
        elementHeight           = BAR_HEIGHT,
        fixedWidth              = true,
        hSpacing                = BORDER_SIZE * 2 + 2,

        value                   = Wow.ClassPower(),
        minMaxValues            = Wow.ClassPowerMax(),
        visible                 = Wow.ClassPowerUsable(),
    },

    -- Nameplate with Indicators
    [AshUnitFrame.UnitFrame]    = {
        clampedToScreen         = true,

        NameLabel               = {
            drawLayer           = "OVERLAY",
            location            = { Anchor("TOPRIGHT", 0, -4 - BAR_HEIGHT, "HealthBar", "BOTTOMRIGHT") },
            textColor           = Wow.UnitExtendColor(),
        },
        LevelLabel              = {
            location            = { Anchor("RIGHT", -5, 0, "NameLabel", "LEFT") },
        },
        Label                   = {
            location            = { Anchor("LEFT", 0, 0, "LevelLabel", "RIGHT") },
            text                = Wow.UnitClassification():Map(function(state) return CLASSICFICATION_ELITE[state] and "+" or "" end),
            textColor           = Wow.UnitClassificationColor(),
        },
        HealthBar               = {
            SHARE_STATUSBAR_SKIN,

            location            = { Anchor("TOPLEFT"), Anchor("BOTTOMRIGHT") },
            height              = BAR_HEIGHT,
            statusBarColor      = Wow.UnitExtendColor(true),
            value               = NIL,
            smoothValue         = Wow.UnitHealth(),
            backgroundFrame     = {
                backdropBorderColor = Wow.UnitIsTarget():Map(function(val) return val and Color.WHITE or  Color.BLACK end),
            },
        },
        PowerBar                = {
            SHARE_STATUSBAR_SKIN,

            location            = { Anchor("TOPLEFT", 0, -BORDER_SIZE, nil, "BOTTOMLEFT"), Anchor("RIGHT") },
            height              = BAR_HEIGHT,
            visible             = Wow.UnitIsPlayer(),
        },
        RaidTargetIcon          = {
            location            = { Anchor("LEFT", 2, 0, "HealthBar", "RIGHT") }
        },
        CastBar                 = {
            SHARE_STATUSBAR_SKIN,

            backgroundFrame     = {
                backdropBorderColor = Wow.UnitIsTarget():Map(function(val) return val and Color.WHITE or Color.BLACK end),
            },

            frameStrata         = "HIGH",
            statusBarColor      = Color.MAGE,

            height              = BAR_HEIGHT,
            location            = { Anchor("TOPLEFT", 0, -BORDER_SIZE, nil, "BOTTOMLEFT"), Anchor("RIGHT") },

            CooldownLabel       = {
                fontObject      = TextStatusBarText,
                location        = { Anchor("LEFT", 0, 0, nil, "RIGHT")},
                autoColor       = false,
                justifyH        = "LEFT",
                cooldown        = Wow.UnitCastCooldown(),
            },

            Label               = {
                justifyH        = "CENTER",
                drawLayer       = "OVERLAY",
                fontObject      = GameFontHighlight,
                location        = { Anchor("CENTER") },
                text            = Wow.UnitCastName(),
            },

            Label2              = {
                justifyH        = "LEFT",
                drawLayer       = "OVERLAY",
                fontObject      = GameFontHighlight,
                location        = { Anchor("LEFT", 0, 0, "CooldownLabel", "RIGHT") },
                textColor       = Color.RED,
                text            = Wow.UnitCastDelay():Map(function(delay) return delay and delay > 0 and ("(+%.1f)"):format(delay) or "" end),
            },

            IconFrame           = {
                size            = Size(16, 16),
                location        = { Anchor("RIGHT", -2, BAR_HEIGHT, nil, "LEFT") },
                frameStrata     = "BACKGROUND",
                backdrop        = {
                    edgeFile    = [[Interface\ChatFrame\CHATFRAMEBACKGROUND]],
                    edgeSize    = ICON_BORDER_SIZE,
                },
                backdropBorderColor = Wow.UnitCastInterruptible():Map(function(val) return val and CASTBAR_NORMAL_COLOR or CASTBAR_NONINTERRUPTIBLE_COLOR end),

                IconTexture     = {
                    file        = Wow.UnitCastIcon(),
                    location    = { Anchor("TOPLEFT", ICON_BORDER_SIZE, -ICON_BORDER_SIZE), Anchor("BOTTOMRIGHT", -ICON_BORDER_SIZE, ICON_BORDER_SIZE) },
                    texCoords   = RectType(0.1, 0.9, 0.1, 0.9),
                }
            },
        },

        -- Aura Panels
        BuffPanel               = {
            elementType         = AshAuraPanelIcon,
            rowCount            = 3,
            columnCount         = 4,
            elementWidth        = 18,
            elementHeight       = 18,
            hSpacing            = 1,
            vSpacing            = 1,
            orientation         = Orientation.HORIZONTAL,
            topToBottom         = false,
            leftToRight         = true,
            location            = { Anchor("BOTTOMLEFT", 0, 4, "HealthBar", "TOPLEFT") },

            auraFilter          = "HELPFUL",
        },
        DebuffPanel             = {
            elementType         = AshAuraPanelIcon,
            rowCount            = 3,
            columnCount         = 4,
            elementWidth        = 18,
            elementHeight       = 18,
            hSpacing            = 1,
            vSpacing            = 1,
            orientation         = Orientation.VERTICAL,
            topToBottom         = false,
            leftToRight         = false,
            location            = { Anchor("BOTTOMRIGHT", 0, 4, "HealthBar", "TOPRIGHT") },

            auraFilter          = "HARMFUL",
        },
    },
})