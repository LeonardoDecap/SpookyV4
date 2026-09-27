local TriggerBot
local CPS
local rayParams = RaycastParams.new()
local diagTimes = {}
local diagSeen = {}
local function combatDiag(stage, detail)
	local now = tick()
	if diagSeen[stage] or now - (diagTimes[stage] or -math.huge) < 5 then return end
	diagSeen[stage] = true
	diagTimes[stage] = now
	vape:CreateNotification('SpookyV4 CombatDiag', 'TriggerBot: '..stage..(detail and ' - '..detail or ''), 5)
end

TriggerBot = vape.Categories.Combat:CreateModule({
	Name = 'TriggerBot',
	Function = function(callback)
		if callback then
			table.clear(diagSeen)
			combatDiag('enabled')
			repeat
				local doAttack
				if not bedwars.AppController:isLayerOpen(bedwars.UILayers.MAIN) then
					if entitylib.isAlive and store.hand.toolType == 'sword' and bedwars.DaoController.chargingMaid == nil then
						combatDiag('eligible', store.hand.tool and store.hand.tool.Name)
						local attackRange = bedwars.ItemMeta[store.hand.tool.Name].sword.attackRange
						rayParams.FilterDescendantsInstances = {lplr.Character}

						local unit = lplr:GetMouse().UnitRay
						local localPos = entitylib.character.RootPart.Position
						local rayRange = (attackRange or 14.4)
						local ray = bedwars.QueryUtil:raycast(unit.Origin, unit.Direction * 200, rayParams)
						if ray and (localPos - ray.Instance.Position).Magnitude <= rayRange then
							local limit = (attackRange)
							for _, ent in entitylib.List do
								doAttack = ent.Targetable and ray.Instance:IsDescendantOf(ent.Character) and (localPos - ent.RootPart.Position).Magnitude <= rayRange
								if doAttack then
									break
								end
							end
						end

						doAttack = doAttack or bedwars.SwordController:getTargetInRegion(attackRange or 3.8 * 3, 0)
						if doAttack then
							combatDiag('swingSwordAtMouse call')
							bedwars.SwordController:swingSwordAtMouse()
							combatDiag('swingSwordAtMouse returned')
						else
							combatDiag('no region target')
						end
					else
						local chargingMaid = bedwars.DaoController and bedwars.DaoController.chargingMaid
						combatDiag('eligibility gate', 'alive='..tostring(entitylib.isAlive)..', hand='..tostring(store.hand and store.hand.toolType)..', maid='..tostring(chargingMaid))
					end
				else
					combatDiag('GUI gate')
				end

				task.wait(doAttack and 1 / CPS.GetRandomValue() or 0.016)
			until not TriggerBot.Enabled
		end
	end,
	Tooltip = 'Automatically swings when hovering over a entity'
})
CPS = TriggerBot:CreateTwoSlider({
	Name = 'CPS',
	Min = 1,
	Max = 9,
	DefaultMin = 7,
	DefaultMax = 7
})