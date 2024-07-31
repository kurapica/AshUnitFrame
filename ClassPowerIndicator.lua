--========================================================--
--                Aim Class Power Indicator               --
--                                                        --
-- Author      :  kurapica125@outlook.com                 --
-- Create Date :  2021/05/07                              --
--========================================================--

--========================================================--
Scorpio          "AshUnitFrame.Indicator.ClassPower" "1.0.0"
--========================================================--

namespace "AshUnitFrame"

__Sealed__() class "ClassPowerBarElement" (function(_ENV)
    inherit "CooldownStatusBar"

    __Observable__()
    property "Activated"        { type = Boolean, default = false }
end)

__ChildProperty__(AshUnitFrame.UnitFrame, "ClassPowerBar")
__Sealed__() class "ClassPowerBar"   (function(_ENV)
    inherit "ElementPanel"

    local playerClass           = select(2, UnitClass("player"))
    local ACTIVE_LIMIT          = playerClass == "PALADIN" and 3 or playerClass == "ROGUE" and 5 or 100
    local USE_MAX_LIMIT         = ACTIVE_LIMIT == 100

    if playerClass == "DEATHKNIGHT" then
        local tsort             = table.sort

        local function RuneComparison(runeAIndex, runeBIndex)
            local runeAStart, runeADuration, runeARuneReady = GetRuneCooldown(runeAIndex)
            local runeBStart, runeBDuration, runeBRuneReady = GetRuneCooldown(runeBIndex)

            if (runeARuneReady ~= runeBRuneReady) then
                return runeARuneReady
            end

            if (runeAStart ~= runeBStart) then
                return runeAStart < runeBStart
            end

            return runeAIndex < runeBIndex
        end

        property "Value"        {
            set                 = function (self, value)
                tsort(self.RuneIndexes, RuneComparison)

                for i = 1, #self.RuneIndexes do
                    local s,d,r = GetRuneCooldown(self.RuneIndexes[i])
                    local ele   = self.Elements[i]

                    ele.Activated = r
                    ele:SetCooldown(s or 0, d or 0)
                end
            end
        }

        property "MinMaxValues" {
            set                 = function(self, minMax)
                local max       = minMax.max
                self.Count  = max

                wipe(self.RuneIndexes)
                for i = 1, max do
                    self.RuneIndexes[i] = i
                end
            end
        }

        function __ctor(self)
            self.RuneIndexes    = {1, 2, 3, 4, 5, 6}
            self.Count          = 6
        end
    else
        property "Value"        {
            set                 = function(self, value)
                if self.Count > 1 then
                    local actived   = value >= ACTIVE_LIMIT
                    for i = 1, self.Count do
                        local ele   = self.Elements[i]
                        if value >= i then
                            ele:SetValue(100)
                            ele.Activated = actived
                        else
                            ele:SetValue(0)
                            ele.Activated = false
                        end
                    end
                else
                    self.Elements[1]:SetValue(value)
                    self.Elements[1].Activated = false
                end
            end
        }

        property "MinMaxValues" {
            set                 = function(self, minMax)
                local max       = minMax.max
                if max > 8 then
                    self.Count  = 1
                    self.Elements[1]:SetMinMaxValues(0, max)
                else
                    self.Count  = max
                    if USE_MAX_LIMIT then ACTIVE_LIMIT = max end

                    for i = 1, max do
                        self.Elements[i]:SetMinMaxValues(0, 100)
                    end
                end
            end
        }
    end

    property "ElementType"      { set = false, default = ClassPowerBarElement }
end)
