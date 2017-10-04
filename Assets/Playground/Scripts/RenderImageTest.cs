using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class RenderImageTest : MonoBehaviour {
    public Material material;

    private void OnRenderImage(RenderTexture source, RenderTexture destination) {
        if(material) {
            Graphics.Blit(source, destination, material);
        } else {
            Graphics.Blit(source, destination);
        }
    }
}
