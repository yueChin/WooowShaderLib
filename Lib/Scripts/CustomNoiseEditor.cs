using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

public class CustomNoiseEditor : ShaderGUI
{
    public enum NoiseType
    {
        Value,
        Perlin,
        Simple,
        Voronoi,
        FBM
    }

    private NoiseType noiseType;
    private Material material;

    private GUIContent uIContent = new GUIContent();

    public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] props)
    {
        Material targetMat = materialEditor.target as Material;

        var scale = FindProperty("_UVScale", props);
        uIContent.text = "UV 缩放";
        materialEditor.ShaderProperty(scale, uIContent);

        var uvTiling = FindProperty("_UVTiling", props);
        uIContent.text = "UV 偏移";
        materialEditor.ShaderProperty(uvTiling, uIContent);

        var invertNoise = FindProperty("_InvertNoise", props);
        uIContent.text = "噪声反色";
        materialEditor.ShaderProperty(invertNoise, uIContent);

        EditorGUI.BeginChangeCheck();
        noiseType = (NoiseType)EditorGUILayout.EnumPopup("噪声类型", noiseType);
        if (EditorGUI.EndChangeCheck())
        {
            SetKeywords(targetMat);
        }
    }

    private void SetKeywords(Material material)
    {
        SetKeyword(material, "VALUE", noiseType == NoiseType.Value);
        SetKeyword(material, "PRELIN", noiseType == NoiseType.Perlin);
        SetKeyword(material, "SIMPLE", noiseType == NoiseType.Simple);
        SetKeyword(material, "VORONOI", noiseType == NoiseType.Voronoi);
        SetKeyword(material, "FBM", noiseType == NoiseType.FBM);
    }
    private void SetKeyword(Material material, string keyword, bool state)
    {
        if (state)
            material.EnableKeyword(keyword);
        else
            material.DisableKeyword(keyword);
    }
}