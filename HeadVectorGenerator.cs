using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HeadVectorGenerator : MonoBehaviour
{
    public Transform HeadBoneTransform;
    public Transform HeadFormwardTransform;
    public Transform HeadRightTransform;

    private Renderer[] allRenderers;

    private int HeadForwardID = Shader.PropertyToID("_HeadForward");
    private int HeadRightID = Shader.PropertyToID("_HeadForward");
#if UNITY_EDITOR
    private void OnValidate() 
    {
        LateUpdate();
    }
#endif
    private void LateUpdate() 
    {
        if (allRenderers == null)
        {
            allRenderers = GetComponentsInChildren<Renderer>(true);
        }

        for (int i = 0; i < allRenderers.Length;++i)
        {
            Renderer r = allRenderers[i];
            foreach (Material mat in r.sharedMaterials)
            {
                if (mat.shader)
                {
                    if (mat.shader.name == "Unlit/SRUniversal")
                    {
                        mat.SetVector(HeadForwardID, HeadFormwardTransform.position - HeadBoneTransform.position);
                        mat.SetVector(HeadRightID, HeadRightTransform.position - HeadBoneTransform.position);
                    }
                }
            }
        }
    }
}
