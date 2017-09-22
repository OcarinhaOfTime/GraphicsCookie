using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;
using UnityEditor;

public class TexturePacker : EditorWindow {
    public Texture2D textureR;
    public Texture2D textureG;
    public Texture2D textureB;
    public Texture2D textureA;

    [MenuItem("Window/TexturePacker")]
    public static void ShowWindow() {
        GetWindow<TexturePacker>();
    }

    private void OnGUI() {
        textureR = (Texture2D)EditorGUILayout.ObjectField("textureR", textureR, typeof(Texture2D), false);
        textureG = (Texture2D)EditorGUILayout.ObjectField("textureG", textureG, typeof(Texture2D), false);
        textureB = (Texture2D)EditorGUILayout.ObjectField("textureB", textureB, typeof(Texture2D), false);
        textureA = (Texture2D)EditorGUILayout.ObjectField("textureA", textureA, typeof(Texture2D), false);

        if (GUILayout.Button("Pack")) {
            Texture2D tex = PackTexture();
            string path = EditorUtility.SaveFilePanelInProject("Pack Textures", "", "png", "Save new packed texture");
            Debug.Log(path);
            File.WriteAllBytes(path, tex.EncodeToPNG());
            AssetDatabase.Refresh();
        }
    }

    Texture2D PackTexture() {
        Texture2D tex = new Texture2D(textureR.width, textureR.height);

        for(int x=0; x< tex.width; x++) {
            for(int y=0; y< tex.height; y++) {
                var r = textureR.GetPixel(x, y).r;
                var g = textureG.GetPixel(x, y).r;
                var b = textureB.GetPixel(x, y).r;
                var a = textureA.GetPixel(x, y).r;
                tex.SetPixel(x, y, new Color(r, g, b, a));
            }
        }

        tex.Apply();
        return tex;
    }
}
