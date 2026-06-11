AddCSLuaFile();
ENT.Type = "ai"
ENT.Base = "base_ai"

ENT.PrintName	= "Help NPC"
ENT.Author	= "Nitoria"
ENT.category = "Nitoria NPCs"

ENT.Spawnable	= true
ENT.AdminOnly	= true


function ENT:Initialize()
	if (SERVER) then
		self:SetModel( "models/Humans/Group02/Female_02.mdl" )
		self:SetHullType( HULL_HUMAN )
		self:SetHullSizeNormal( )
		self:SetNPCState( NPC_STATE_SCRIPT )
		self:SetSolid( SOLID_BBOX )
		self:CapabilitiesAdd( CAP_ANIMATEDFACE )
		self:SetUseType( SIMPLE_USE )
		--self:DropToFloorent()
	end
end

if (SERVER) then

	util.AddNetworkString("ui_help_npc")
	util.AddNetworkString("gun_license")

	function ENT:OnTakeDamage()
	    return false
	end 

	function ENT:AcceptInput( Name, Activator, Caller )    
	    if Name == "Use" and Caller:IsPlayer() then
		    net.Start("ui_help_npc")
		    	net.WriteBool(Caller:getChar():getData("exam_cooldown", false))
		    net.Send(Caller)
	    end
	end

	net.Receive("gun_license", function(len, ply)
		local client = ply
		local character = client:getChar()
		local passed = net.ReadBool()

		if passed then
			if character:hasMoney(750) then
				client:notify("You've passed the exam, and have purchased a Gun License for $750")
				character:takeMoney(750)
				character:getInv():add("permit_gun")
				character:setData("exam_cooldown", true)
				timer.Simple(1800, function()
					character:setData("exam_cooldown", false)
				end)
			else
				client:notify("You have passed the exam, however, you do not have enough money to purchase the license.")
			end
		else
			client:notify("You have failed the exam, try again later.")
			character:setData("exam_cooldown", true)
			timer.Simple(1800, function()
				character:setData("exam_cooldown", false)
			end)
		end
	end)
end

if (CLIENT) then

	net.Receive("ui_help_npc",function()
		cooldown = net.ReadBool()

		licenses = {
		"permit_drivers",
		"permit_boating",
		"permit_business",
		}

	    nitoria.dialog("Gina Potenza", "models/Humans/Group02/Female_02.mdl", "Secretary", "City Hall", function(ply)
	    	nitoria.dialogframe("Gina Potenza", "models/Humans/Group02/Female_02.mdl", "Secretary", "City Hall")

	    	nitoria.dialogtext("Welcome to City Hall, how may I help you today?")

	    	nitoria.dialogbutton("I'm seeing errors (Content)", 40, function()
			gui.OpenURL("https://steamcommunity.com/sharedfiles/filedetails/?id=1689316394")
	    		self:Remove()
	    	end)

	    	nitoria.dialogbutton("I'd like to aquire a license.", 40, function()
		    	self:Remove()

				nitoria.dialogframe("Gina Potenza", "models/Humans/Group02/Female_02.mdl", "Secretary", "City Hall")

		    	nitoria.dialogtext("Okay, what kind of license are you interested in?")

		    	nitoria.dialogbutton("Gun License ($750)", 60, function()

		    		self:Remove()

		    		if LocalPlayer():getChar():hasMoney(750) then
				    	if cooldown then
				    		LocalPlayer():ChatPrint("You must wait before taking the exam again!")
				    	else
							local frame = vgui.Create( "DFrame" )
							frame:SetTitle("Weapon License Exam")
							frame:SetSize(ScrW() - 450, 450)
							frame:Center()
							frame:MakePopup()

							local question = vgui.Create( "DComboBox", frame )
							question:SetSize( frame:GetWide(), 36 )
							question:Dock(TOP)
							question:SetValue( "When is it legal to discharge your firearm in public?" )
							question:AddChoice("When you feel threatened by another's actions")
							question:AddChoice("When your life is directly in danger")
							question:AddChoice("When someone makes a threat towards your well being")
							question:AddChoice("All")
							question.Answer = "When your life is directly in danger"

							local question2 = vgui.Create( "DComboBox", frame )
							question2:SetSize( frame:GetWide(), 36 )
							question2:Dock(TOP)
							question2:SetValue( "When would brandishing your weapon be appropriate?" )
							question2:AddChoice("When dealing with a hostile person who is also armed")
							question2:AddChoice("Never, you should never use your weapon")
							question2:AddChoice("To assist police")
							question2:AddChoice("All")
							question2.Answer = "When dealing with a hostile person who is also armed"

							local question3 = vgui.Create( "DComboBox", frame )
							question3:SetSize( frame:GetWide(), 36 )
							question3:Dock(TOP)
							question3:SetValue( "In the event of a shootout in a public area, when would it be appropirate to intervene?" )
							question3:AddChoice("When you're directly in danger")
							question3:AddChoice("When others are in danger")
							question3:AddChoice("To prevent danger")
							question3:AddChoice("All")
							question3.Answer = "All"

							local question4 = vgui.Create( "DComboBox", frame )
							question4:SetSize( frame:GetWide(), 36 )
							question4:Dock(TOP)
							question4:SetValue( "In the event of an armed person robbing your home what should you do?" )
							question4:AddChoice("Confront the robber immediately and shoot them without prior warning or action")
							question4:AddChoice("Notify the police and secure the immediate room")
							question4:AddChoice("All")
							question4.Answer = "Notify the police and secure the immediate room"

							local question5 = vgui.Create( "DComboBox", frame )
							question5:SetSize( frame:GetWide(), 36 )
							question5:Dock(TOP)
							question5:SetValue( "After being robbed at gun point what should you do?" )
							question5:AddChoice("Shoot the person who robbed")
							question5:AddChoice("Hold them at gunpoint and alert authorities")
							question5:AddChoice("Notify the authorities about the incident")
							question5:AddChoice("All")
							question5.Answer = "Notify the authorities about the incident"

							local question6 = vgui.Create( "DComboBox", frame )
							question6:SetSize( frame:GetWide(), 36 )
							question6:Dock(TOP)
							question6:SetValue( "What should you do when you find a firearm that is not licensed to you?" )
							question6:AddChoice("Take it and sell it off to someone else")
							question6:AddChoice("Turn it into the gun store for them to resell")
							question6:AddChoice("Turn it into the authorities for them to process and properly dispose of it")
							question6:AddChoice("All")
							question6.Answer = "Turn it into the authorities for them to process and properly dispose of it"


							local question7 = vgui.Create( "DComboBox", frame )
							question7:SetSize( frame:GetWide(), 36 )
							question7:Dock(TOP)
							question7:SetValue( "If you are carrying and are pulled over by a police officer, what should you do?" )
							question7:AddChoice("Say nothing to protect yourself and the officer")
							question7:AddChoice("Inform the officer that you are armed and to advise on what you should do")
							question7:AddChoice("Get out of the car and announce that you are carrying")
							question7:AddChoice("All")
							question7.Answer = "Inform the officer that you are armed and to advise on what you should do"

							local question8 = vgui.Create( "DComboBox", frame )
							question8:SetSize( frame:GetWide(), 36 )
							question8:Dock(TOP)
							question8:SetValue( "If you encounter a civil crime occuring and you feel the need to intervene, what should you do?" )
							question8:AddChoice("Use your firearm to defend others and yourself")
							question8:AddChoice("See if you can resolve it without violence")
							question8:AddChoice("Don’t get involved and contact the authorities")
							question8:AddChoice("All")
							question8.Answer = "Don’t get involved and contact the authorities"

							local submit = vgui.Create("DButton", frame)
							submit:SetText("Submit")
							submit:Dock(TOP)
							submit:SetTall(50)
							submit.DoClick = function()
								self:Remove()
								net.Start("gun_license")
									if (question:GetValue() == question.Answer) and (question2:GetValue() == question2.Answer) and (question3:GetValue() == question3.Answer) and (question4:GetValue() == question4.Answer) and (question5:GetValue() == question5.Answer) then
										if (question6:GetValue() == question6.Answer) and (question7:GetValue() == question7.Answer) and (question8:GetValue() == question8.Answer) then
											net.WriteBool(true)
										else
											net.WriteBool(false)
										end
									else
										net.WriteBool(false)
									end
								net.SendToServer()
							end
						end
					else
						LocalPlayer():ChatPrint("You cannot afford this.")	
					end															
		    	end)		
	    	end)
		end)
	end)

	local TEXT_OFFSET = Vector(0, 0, 20)
	local toScreen = FindMetaTable("Vector").ToScreen
	local colorAlpha = ColorAlpha
	local drawText = nut.util.drawText
	local configGet = nut.config.get
	
		ENT.DrawEntityInfo = true

	function ENT:onDrawEntityInfo(alpha)
		local position = toScreen(self.LocalToWorld(self, self.OBBCenter(self)) + TEXT_OFFSET)
		local x, y = position.x, position.y
		--local desc = self.getNetVar(self, "desc")

		drawText("Gina Potenza", x, y, colorAlpha(configGet("color"), alpha), 1, 1, nil, alpha * 0.65)

		--if (desc) then
			drawText("Need anything?", x, y + 16, colorAlpha(color_white, alpha), 1, 1, "nutSmallFont", alpha * 0.65)
		--end
	end
end