WorkerScript.onMessage = function(msg) {
                        var ind = msg.ind;
                        var model = msg.model
                        for(var i=0;i<model.count;i++)
                        {
                         model.setProperty(i,"selected",false);
                        }
                        console.log("index : "+ind);
                        model.setProperty(ind,"selected",true);
                        model.sync();
}
