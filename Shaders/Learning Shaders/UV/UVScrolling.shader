Shader "SF/Debugging/UV Scrolling"
{
    Properties
    {
         // The 2D value type declared here can be read via a sampler2D type in code to get data such as:
         // Tiling, offset, and the texture.
         [MainTexture] _BaseMap("Base Map", 2D) = "white" {}
         _ScrollingSpeed ("Scrolling Speed", Vector) = (0,0,0,0)
    }
    SubShader
    {
         Tags { "RenderType"="Opaque" }
         LOD 100
 
        Pass
        {
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
        
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };
        
            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            // Match the name of your declared shader property from your Properties block.
            sampler2D _BaseMap;
            float4 _ScrollingSpeed;
        
            v2f vert (appdata v)
            {
                v2f o;
                /* UnityObjectToClipPos takes the position of vertices of an object and convert them
                * to clip space to prepare for the fragment shader.*/
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }
        
            fixed4 frag (v2f i) : SV_Target
            {
                // Final UV = Base UV + (Scroll Speed * Time Factor)
                // _Time.y = base t and _Time.yy says multiple the other vector
                // which would be the _ScrollingSpeed x and y value by the _Time.y value.

                /* frac is useful for preventing precision errors that can happen as 
                as the current play session goes past a certain time. */
                i.uv = i.uv + frac(_ScrollingSpeed * _Time.yy);
                fixed4 col = tex2D(_BaseMap, i.uv);
                return col;
            }
        
            ENDHLSL
        }
    }
}