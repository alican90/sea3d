SEA3D.Pool = function(url, endFunction){
	this.models = [];
    this.endFunction = endFunction ||  function() {};
    this.load(url);
}

SEA3D.Pool.prototype = {
    constructor: SEA3D.Pool,

    load : function(url){
    	var SeaLoader = new THREE.SEA3D( true );
        var parent = this;
    	SeaLoader.onComplete = function( e ) {
            setTimeout( parent.detectMesh, 100, SeaLoader, parent);
    	}
    	SeaLoader.load( url );
    },

    detectMesh : function(SeaLoader, parent){
        var j, m, anim, morph, loop;
        for ( var i=0, l= SeaLoader.meshes.length; i < l; i++){
            m = SeaLoader.meshes[i];
            anim = [];
            loop = [];
            morph = [];
            if(m.animations){
                for ( j=0; j !== m.animations.length; j++){
                    anim[j] = m.animations[j].name;
                    loop[j] = m.animations[j].loop;
                }
            }
            if(m.geometry.morphTargets){
                for ( j=0; j < m.geometry.morphTargets.length; j++){
                    morph[i] = m.geometry.morphTargets[j].name;
                }
            }

            parent.models[i] = { name:m.name, geo:m.geometry, anim:anim, loop:loop, morph:morph };
        }
        parent.endFunction();
    },

    getMorphs : function (name){
        var a = [];
        var i = this.models.length;
        while(i--){
            if(this.models[i].name === name){
                a = this.models[i].morph;
            }
        }
        return a;
    },

    getAnimations : function (name){
        var a = [];
        var i = this.models.length;
        while(i--){
            if(this.models[i].name === name){
                a[0] = this.models[i].anim;
                a[1] = this.models[i].loop;
            }
        }
        return a;
    },

    getGeometry : function (name, AutoScale, Scale, Axe){
        var autoScale = AutoScale || false;
        var g;
        for (var i=0, l=this.models.length; i < l; i++){
            if(this.models[i].name === name){
                g = this.models[i].geo;
            }
        }
        if(autoScale)this.scaleGeometry(g, Scale, Axe);
        return g;
    },

    scaleGeometry : function (geometry, Scale, Axe) {
        var s = Scale || 1;
        var axe = Axe || 'z';

        for( var i = 0; i < geometry.vertices.length; i++) {
            var vertex  = geometry.vertices[i];
            if(axe==='x')vertex.x *= -s;
            else vertex.x *= s;
            if(axe==='y')vertex.y *= -s;
            else vertex.y *= s;
            if(axe==='z')vertex.z *= -s;
            else vertex.z *= s;
        }
        geometry.computeFaceNormals();
        geometry.computeVertexNormals();
        geometry.verticesNeedUpdate = true;
    }
}