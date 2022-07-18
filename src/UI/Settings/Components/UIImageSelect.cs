using Godot;
using System;

public class UIImageSelect : Control
{
    private Control _grid;
    private Thread _thread = new Thread();
    private ButtonGroup _button_group = new ButtonGroup();
    public Godot.Collections.Array Images
    {
        set
        {
            Images = value;
            _thread.Start(this, "_display_images");
        }
        get {return Images;}
    }


    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        _grid = (Control)FindNode("ImgGrid");
    }

    public override void _EnterTree()
    {
        if (this.GetParent<Node>() == this.GetTree().Root)
        {
            this.Visible = true;
        }
    }
    public override void _ExitTree()
    {
        _thread.WaitToFinish();
    }

    private void _display_images()
    {
        _clear_images();
        foreach (Texture img in Images)
        {
            PackedScene bgBtnScene = this.GetNode<ResourcePreloader>("ResourcePreloader").GetResource("BgBtn") as PackedScene;
            Button bgBtn = bgBtnScene.Instance() as Button;
            _grid.AddChild(bgBtn);
            bgBtn.Set("texture", img);
            bgBtn.Set("locked", img.HasMeta("locked"));
            bgBtn.SetPressedNoSignal(img.HasMeta("current"));
            bgBtn.Group = _button_group;

        }
    }

    private void _clear_images()
    {
        foreach (Node child in _grid.GetChildren())
        {
            child.QueueFree();
        }
    }
}
