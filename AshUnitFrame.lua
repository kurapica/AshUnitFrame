--========================================================--
--                Aim                                     --
--                                                        --
-- Author      :  kurapica125@outlook.com                 --
-- Create Date :  2021/05/07                              --
--========================================================--

--========================================================--
Scorpio           "AshUnitFrame"                     "1.0.0"
--========================================================--

namespace "AshUnitFrame"

import "System.Reactive"

export { strupper = string.upper }

-----------------------------------------------------------
-- Aura Panel Icon
-----------------------------------------------------------
__Sealed__() class "AshAuraPanelIcon"   { Scorpio.Secure.UnitFrame.AuraPanelIcon }
__Sealed__() class "AshTotemPanelIcon"  { Scorpio.Secure.UnitFrame.TotemPanelIcon}

-- The unit and hidden frames
_BlizzardUnits                  = {
    player                      = {
        hideUnitFrames          = { "PlayerFrame", "ComboFrame", "RuneFrame", "CastingBarFrame" },
        styles                  = {
            ClassPowerBar       = {
                location        = { Anchor("BOTTOMLEFT", 0, 2, "HealthBar", "TOPLEFT"), Anchor("BOTTOMRIGHT", 0, 2, "HealthBar", "TOPRIGHT") },
            },
            PowerLabel          = {
                location        = { Anchor("TOPLEFT", 0, -4, "PowerBar", "BOTTOMLEFT") },
            },
            TotemPanel          = {
                elementType     = AshTotemPanelIcon,
                elementWidth    = 18,
                elementHeight   = 18,
                location        = { Anchor("TOP", 0, -4, "PowerBar", "BOTTOM") },
            },
            BuffPanel           = NIL,
            DebuffPanel         = NIL,
        },
    },
    pet                         = {
        hideUnitFrames          = { "PetFrame" },
        styles                  = {
            CastBar             = NIL,
            PowerLabel          = NIL,
            DebuffPanel         = NIL,
        }
    },
    target                      = {
        hideUnitFrames          = { "TargetFrame" },
    },
    targettarget                = {
        styles                  = {
            PowerBar            = NIL,
            RaidTargetIcon      = NIL,
            CastBar             = NIL,
            BuffPanel           = NIL,
            DebuffPanel         = NIL,
        }
    },
    focus                       = {
        hideUnitFrames          = { "FocusFrame" },
        styles                  = {
            PowerBar            = NIL,
            BuffPanel           = NIL,
            DebuffPanel         = NIL,
        }
    },
    ["boss%d"]                  = {
        count                   = 5,
        hideUnitFrames          = {  "Boss%dTargetFrame" },
        styles                  = {
        }
    },
    ["party%d"]                 = {
        count                   = 4,
        hideUnitFrames          = { "PartyMemberFrame%d" },
        styles                  = {
        }
    },
    ["partypet%d"]              = {
        count                   = 4,
        hideUnitFrames          = { "partypet%d" },
        styles                  = {
            PowerBar            = NIL,
            RaidTargetIcon      = NIL,
            CastBar             = NIL,
            BuffPanel           = NIL,
            DebuffPanel         = NIL,
        }
    },
    focustarget                 = {
        styles                  = {
            PowerBar            = NIL,
            RaidTargetIcon      = NIL,
            CastBar             = NIL,
            BuffPanel           = NIL,
            DebuffPanel         = NIL,
        }
    },
}

HIDDEN_FRAME                    = CreateFrame("Frame")
HIDDEN_FRAME:Hide()
RECYCLE_MASKS                   = Recycle(Scorpio.Widget.Mask, "AshUnitFrame_Mask%d", HIDDEN_FRAME)
UNLOCK_FRAMES                   = false
UNIT_FRAMES                     = List()

_DefaultSize                    = Size(100, 24)
_DefaultLocation                = { Anchor("CENTER") }

-----------------------------------------------------------
-- Template Class
-----------------------------------------------------------
__Sealed__()
class "UnitFrame" { Scorpio.Secure.UnitFrame }

-----------------------------------------------------------
-- Addon Event Handler
-----------------------------------------------------------
function OnEnable(self)
    OnEnable                    = nil

    _SVDB                       = SVManager("AshUnitFrame_DB", "AshUnitFrame_CharDB")
    _SVDB:SetDefault{ Location = {}, Size = {} }
    _SVDB.Char:SetDefault{ HideUnit = {} }

    for unit, config in pairs(_BlizzardUnits) do
        for i = 1, config.count or 1 do
            if config.hideUnitFrames then
                for _, name in ipairs(config.hideUnitFrames) do
                    local frame     = _G[name:format(i)]
                    if frame then
                        frame:UnregisterAllEvents()
                        frame:Hide()
                        frame:SetParent(HIDDEN_FRAME)
                        if frame.healthbar then frame.healthbar:UnregisterAllEvents() end
                        if frame.manabar then frame.manabar:UnregisterAllEvents() end
                        if frame.spellbar then frame.spellbar:UnregisterAllEvents() end
                        if frame.powerBarAlt then frame.powerBarAlt:UnregisterAllEvents() end
                    end
                end
            end

            local cunit             = unit:format(i)
            local unitFrm           = UnitFrame("AshUnitFrame" .. cunit:gsub("^%w", strupper))
            UNIT_FRAMES:Insert(unitFrm)

            unitFrm.UnitWatchEnabled= true
            unitFrm.TargetUnit      = cunit
            Style[unitFrm].Size     = _SVDB.Size[cunit] or _DefaultSize
            Style[unitFrm].Location = _SVDB.Location[cunit] or _DefaultLocation
            if not _SVDB.Char.HideUnit[cunit] then
                unitFrm.Unit        = cunit
            else
                unitFrm:Hide()
            end

            if config.styles then
                for k, v in pairs(config.styles) do
                    Style[unitFrm][k] = v
                end
            end

            unitFrm:InstantApplyStyle()
        end

    end
end

__SlashCmd__ "/ashunit" "unlock"
function UnlockUnitFrames()
    if InCombatLockdown() or UNLOCK_FRAMES then return end
    UNLOCK_FRAMES               = true

    Next(function()
        while UNLOCK_FRAMES and not InCombatLockdown() do Next() end
        return UNLOCK_FRAMES and LockUnitFrames()
    end)

    for i, frm in ipairs(UNIT_FRAMES) do
        frm:SetMovable(true)
        frm:SetResizable(true)
        frm.UnitWatchEnabled    = false
        frm:Show()

        frm.Mask                = RECYCLE_MASKS()
        frm.Mask:SetParent(frm)
        frm.Mask:Show()
        frm.Mask:GetChild("KeyBindText"):SetText(frm.TargetUnit)
        frm.Mask:SetToggleState(not _SVDB.Char.HideUnit[frm.TargetUnit])
    end
end

__SlashCmd__ "/ashunit" "lock"
function LockUnitFrames()
    if not UNLOCK_FRAMES then return end
    UNLOCK_FRAMES               = false

    NoCombat(function()
        for i, frm in ipairs(UNIT_FRAMES) do
            frm:SetMovable(false)
            frm:SetResizable(false)
            frm.UnitWatchEnabled= true
            frm:SetShown(not _SVDB.Char.HideUnit[frm.TargetUnit])
        end
    end)

    for i, frm in ipairs(UNIT_FRAMES) do
        RECYCLE_MASKS(frm.Mask)
        frm.Mask                = nil
    end
end

-----------------------------------------------------------
-- Object Event Handler
-----------------------------------------------------------
function RECYCLE_MASKS:OnInit(mask)
    mask.EnableToggle           = true
    mask.OnStopMoving           = ReLocation
    mask.OnStopResizing         = ReSize
    mask.OnToggle               = ToggleState
end

function RECYCLE_MASKS:OnPush(mask)
    mask:SetParent(HIDDEN_FRAME)
    mask:GetChild("KeyBindText"):SetText("")
end

-----------------------------------------------------------
-- Helpers
-----------------------------------------------------------
function ReLocation(self)
    self                        = self:GetParent()
    _SVDB.Location[self.TargetUnit] = Style[self].Location
end

function ReSize(self)
    self                        = self:GetParent()
    _SVDB.Size[self.TargetUnit] = Style[self].Size
end

function ToggleState(self)
    local hideUnit              = not self.ToggleState
    self                        = self:GetParent()
    _SVDB.Char.HideUnit[self.TargetUnit] = hideUnit or nil

    NoCombat(function()
        self.Unit               = not hideUnit and self.TargetUnit or nil
    end)
end