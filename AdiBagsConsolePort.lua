local addonName, addon = ...

local AdiBags = LibStub("AceAddon-3.0"):GetAddon("AdiBags")

local mod = AdiBags:NewModule('ConsolePortSupport', 'ABEvent-1.0')
mod.uiName = 'Console Port support'
mod.uiDesc = 'Console Port Support for AdiBags addon.'

function RegisterBagEvents()
    mod:RegisterMessage("AdiBags_BagOpened", 
        function(event, bagName, bag)
            local frame = bag.frame
            SetOverrideBindingClick(frame, true, "PAD3", addon.handlerButton:GetName())
        end
    )

    mod:RegisterMessage("AdiBags_BagClosed", 
        function(event, bagName, bag)
            local frame = bag.frame
            ClearOverrideBindings(frame)
        end
    )
end

function mod:OnEnable()
    addon.handlerButton = CreateFrame("Button", "AdiBags_ConsolePortSupport_BindingHandlerButton", nil)
    addon.handlerButton:SetScript("OnClick", 
        function(self, button, down)
            local nmod = AdiBags:GetModule("NewItem")
            local button = nmod.button
            button:Click()
        end
    )

    AdiBags:HookBagFrameCreation(mod, 
        function(bag)
            local frame = bag.frame
            ConsolePort:AddInterfaceCursorFrame(frame)
        end
    )

    EventRegistry:RegisterFrameEventAndCallback("PLAYER_ENTERING_WORLD", RegisterBagEvents, self)
    RegisterBagEvents()
end

function mod:OnDisable()
    print("Reload UI to disable AdiBags Console Port support")
end