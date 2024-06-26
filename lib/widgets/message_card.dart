import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:connect/APIS/apis.dart';
import 'package:connect/main.dart';
import 'package:connect/models/message.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({Key? key, required this.message}) : super(key: key);

  final Message message;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    bool isme= API.user.uid==widget.message.fromId;
    return InkWell(
      onLongPress: (){
        _showBottomSheet(isme);
      },
        child:isme ? _greenmessage() : _bluemessage());

  }

  //sender message
  Widget _bluemessage(){
    return Row(
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type==Type.image ? mq.width*0.02 : mq.width*0.04),
            margin: EdgeInsets.symmetric(horizontal: mq.width*0.04, vertical: mq.height*0.01),
            decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20))
            ),



            child: widget.message.type==Type.text ?
            Text(widget.message.msg, style: TextStyle(fontSize: 15, color: Colors.black87),)
                :
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: CachedNetworkImage(
                  imageUrl: widget.message.msg,
                  placeholder: (context, url) =>Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const CircularProgressIndicator(strokeWidth: 2,),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.image, size: 70,)
              ),
            ),          ),
        ),
      ],
    );
  }

  //our message
  Widget _greenmessage(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type==Type.image ? mq.width*0.02 : mq.width*0.04),
            margin: EdgeInsets.symmetric(horizontal: mq.width*0.04, vertical: mq.height*0.01),
            decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20))
            ),



            child: widget.message.type==Type.text ?
                Text(widget.message.msg, style: TextStyle(fontSize: 15, color: Colors.black87),)
                :
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: CachedNetworkImage(
                imageUrl: widget.message.msg,
                placeholder: (context, url) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const CircularProgressIndicator(strokeWidth: 2,),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.image, size: 70,)
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showBottomSheet(bool  isMe) {
    showModalBottomSheet(context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),topRight: Radius.circular(20))),
        builder: (_){
          return ListView(
            shrinkWrap: true,
            children: [
              Container(
                height: 4,
                margin: EdgeInsets.symmetric(vertical: mq.height*0.015,horizontal: mq.width*0.4),
                decoration: BoxDecoration(color: Colors.grey),
              ),

              if(widget.message.type == Type.text)
                _OptionItem(
                    icon: Icon(Icons.copy, color: Colors.blue, size: 26,),
                    name: 'Copy',
                    onTap: () async {
                      await Clipboard.setData(
                          ClipboardData(text: widget.message.msg)).then((
                          value) {
                        Navigator.pop(context);
                      });
                    }),


              if(isMe)
                _OptionItem(icon: Icon(Icons.delete_forever_rounded,color: Colors.red,size: 26,), name: 'Delete',
                    onTap: () async {
                  await API.deletemessage(widget.message).then((value)
                  {Navigator.pop(context);});
                })
            ],
          );
        });
  }
}

class _OptionItem extends StatelessWidget {
  final Icon icon;
  final String name;
  final VoidCallback onTap;
  const _OptionItem({required this.icon,required this.name,required this.onTap,});


  @override
  Widget build(BuildContext context){
    return InkWell(
      onTap: ()=>onTap(),
      child: Padding(
        padding:  EdgeInsets.only(left: mq.width*0.05,bottom: mq.height*0.025),
        child: Row(children: [icon,Flexible(child: Text('    $name',style: TextStyle(fontSize: 20),))
        ],),
      ),
    );
  }
}
