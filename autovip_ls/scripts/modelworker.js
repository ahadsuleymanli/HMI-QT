WorkerScript.onMessage = function(msg) {
                        var ind = msg.ind;
                        var model = msg.model
                        var lightsOff = msg.lightsOff
                        if (typeof lightsOff !== 'undefined'){
                            model.setProperty(ind,"lightsOff",lightsOff)
                            console.log("index : "+ind + " lightsOff: " + lightsOff);
//                            model.setProperty(ind)
                        }
                        else{
                            for(var i=0;i<model.count;i++)
                            {
                                model.setProperty(i,"selected",false);
                            }
                            console.log("index : "+ind);
                            model.setProperty(ind,"selected",true);
                        }

                        model.sync();
}
