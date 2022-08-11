local function no_textures()
	--[[
	MAX FPS BOOSTER  | TRULY DOGSHIT PS1 GRAPHICS
  -- credits to the creator 
  
	-no textures
	-simple shadows
	-simple water
	-no particles, reflections, or post effects
	-simplified hitboxes
	-no rendering tiny parts (<5 studs)
	--faster dex
	-**no terrain at all** | replaced with a huge baseplate | press CTRL+BRACKETS to change the baseplate height
	--]]
	if not game:IsLoaded() then
		game.Loaded:Wait()
		wait(10)
	end

	local function check(inst)
		local class = inst.ClassName
		if class == "Decal" or class == "Texture" then 
			inst.Texture = ""
		elseif class == "SpecialMesh" then 
			inst.TextureId = ""
		elseif class == "ParticleEmitter" then
			inst.Texture = ""
			inst.Rate = 0
		elseif inst:IsA("BasePart") then 
			inst.Material = "SmoothPlastic"
			inst.Reflectance = 0
			inst.CastShadow = false
			if class == "MeshPart" then 
				inst.TextureID = ""
				inst.CollisionFidelity = "Hull"
			elseif class == "UnionOperation" then
				inst.CollisionFidelity = "Hull"
			end
			if inst.Anchored and inst.Size.Magnitude < 5 then
				inst.Transparency = 1
				inst.CanCollide = false
				--inst:Destroy()
			end
		end
	end

	local function removeDups(children)
		if #children > 99 then
			local myname = tostring(game:GetService("Players").LocalPlayer)
			local fake = {Name = myname}
			for i=1,#children do
				local name1 = children[i].Name
				if name1 ~= myname and name1 ~= "Terrain" then
					local moved = false
					for j=i+1,#children do
						if children[j].Name == name1 then
							moved = true
							children[j].Parent = workspace.Terrain
							children[j] = fake
						end
					end
					if moved then 
						children[i].Parent = workspace.Terrain
					end
				end
			end
		end
	end

	settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
	UserSettings():GetService("UserGameSettings").SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1
	settings().Rendering.EagerBulkExecution = false
	settings().Network.IncomingReplicationLag = -1000

	workspace:WaitForChild("Terrain")
	workspace.Terrain.WaterReflectance = 0
	workspace.Terrain.WaterWaveSize = 0
	workspace.Terrain.WaterWaveSpeed = 0
	workspace.Terrain.WaterTransparency = 0

	game:GetService("Lighting").GlobalShadows = false

	workspace.Terrain:Clear()
	local plates = {}
	if not workspace:FindFirstChild("Baseplate") then
		for x=-1,1,2 do
			for z=-1,1,2 do
				local part = Instance.new("Part")
				part.Size = Vector3.new(2048,5,2048)
				part.CFrame = CFrame.new(1024*x,-5,1024*z)
				part.Anchored=true
				part.Material="SmoothPlastic"
				part.Color = Color3.new(0.36,0.6,0.3)
				part.Name = "Baseplate"
				part.Parent= workspace
				plates[#plates+1]= part
			end
		end
	end
	local UIS = game:GetService("UserInputService")
	UIS.InputBegan:Connect(function(input,gpe)
		if gpe==false and UIS:IsKeyDown("LeftControl") then 
			if input.KeyCode==Enum.KeyCode.RightBracket then 
				for _,part in ipairs(plates) do
					part.CFrame=part.CFrame+Vector3.new(0,2.5,0)
				end
			elseif input.KeyCode==Enum.KeyCode.LeftBracket then 
				for _,part in ipairs(plates) do 
					part.CFrame=part.CFrame-Vector3.new(0,2.5,0)
				end
			end
		end
	end)
	wait(0.3)

	while true do
		for _,v in ipairs(game:GetService("Lighting"):GetDescendants()) do
			if v:IsA("PostEffect") then
				v.Enabled = false
			end
		end
		local des = workspace:GetDescendants()
		for i=1,#des do
			check(des[i])
		end
		wait(0.3)
		--faster dex
		removeDups(workspace:GetChildren())

		wait(600)
	end
end

no_textures()
