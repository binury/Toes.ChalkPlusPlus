using GDWeave;
using util.LexicalTransformer;

namespace ChalkPlusPlus;

/*
 The main entrypoint of your mod project
 This code here is invoked by GDWeave when loading your mod's DLL assembly, at runtime
*/

public class Mod : IMod
{
	public Mod(IModInterface mi)
	{
		// var config = new Config(mi.ReadConfig<ConfigFileSchema>());

		mi.RegisterScriptMod(
			new TransformationRuleScriptModBuilder()
				.ForMod(mi)
				.Named("Chalk++ Core Patch")
				.Patching("res://Scenes/Entities/ChalkCanvas/chalk_canvas.gdc")
				.AddRule(
					new TransformationRuleBuilder()
						.Named("Create Canvas.paused property")
						.Do(Operation.Append)
						.Matching(TransformationPatternFactory.CreateGdSnippetPattern("var canvas_mid = 0"))
						.With(
							"""

							var paused = false

							"""
						)
				)
				.AddRule(
					new TransformationRuleBuilder()
						.Named("Amend _chalk_draw to early return when paused")
						.Do(Operation.Append)
						.Matching(
							TransformationPatternFactory.CreateFunctionDefinitionPattern(
								"_chalk_draw",
								["pos", "size", "color"]
							)
						)
						.With(
							"""

							if self.paused: return

							""",
							1
						)
				)
				.Build()
		);

		mi.RegisterScriptMod(
			new TransformationRuleScriptModBuilder()
				.ForMod(mi)
				.Named("Chalk++ Drawing Distance Patch")
				.Patching("res://Scenes/Entities/Player/player.gdc")
				.AddRule(
					new TransformationRuleBuilder()
						.Named("Fix mouse_world_pos pinning to player elevation")
						.Do(Operation.ReplaceAll)
						.Matching(
							TransformationPatternFactory.CreateGdSnippetPattern(
								"mouse_world_pos.y = global_transform.origin.y"
							)
						)
						.With([])
				)
				.Build()
		);
	}

	public void Dispose()
	{
		// Post-injection cleanup (optional)
	}
}
