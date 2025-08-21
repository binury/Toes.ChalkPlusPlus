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
		var config = new Config(mi.ReadConfig<ConfigFileSchema>());

		mi.RegisterScriptMod(
			new TransformationRuleScriptModBuilder()
				.ForMod(mi)
				.Named("Chalk++")
				.Patching("res://Scenes/Entities/ChalkCanvas/chalk_canvas.gdc")
				.AddRule(
					new TransformationRuleBuilder()
						.Named("Create Canvas.paused property")
						.Do(Operation.Append)
						.Matching(
							TransformationPatternFactory.CreateGdSnippetPattern(
								"var canvas_mid = 0"
							)
						)
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
						.Matching(TransformationPatternFactory.CreateFunctionDefinitionPattern("_chalk_draw", ["pos", "size", "color"]))
						.With(
							"""

							if self.paused: return

							""",
							1
						)
				)
				.Build()
		);


	}

	public void Dispose()
	{
		// Post-injection cleanup (optional)
	}
}
