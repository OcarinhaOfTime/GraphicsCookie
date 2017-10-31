using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class OldMovieScreenRender : MonoBehaviour {
    public Material material;

    private void OnRenderImage(RenderTexture source, RenderTexture destination) {
        if (material) {
            Graphics.Blit(source, destination, material);
        } else {
            Graphics.Blit(source, destination);
        }
    }

    private void Update() {
        if (material) {
            material.SetFloat("_RandomValue", Random.Range(-0.1f, 0.1f));
        }
    }
}
