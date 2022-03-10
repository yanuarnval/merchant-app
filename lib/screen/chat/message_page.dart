import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../bloc/event/message_event.dart';
import '../../bloc/message_bloc.dart';
import '../../bloc/profil_bloc.dart';
import '../../bloc/state/message_state.dart';
import '../../model/user_event.dart';
import '../../model/user_state.dart';
import '../../shared/colors_value.dart';

class MessagePage extends StatefulWidget {
  String emailMerchant;

  MessagePage({Key? key, required this.emailMerchant}) : super(key: key);

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final _textMsgController = TextEditingController();
  final _listController = ScrollController();

  @override
  void dispose() {
    // TODO: implement dispose
    _textMsgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<MessageBloc>(create: (_) => MessageBloc()),
            BlocProvider<ProfilBloc>(create: (_) => ProfilBloc()),
          ],
          child: Column(
            children: [_buildHeader(), _buildListMessage(), _buildTextfield()],
          ),
        ),
      ),
    );
  }

  Flexible _buildListMessage() {
    return Flexible(
      flex: 1,
      child: BlocListener<MessageBloc, MessageState>(
        bloc: MessageBloc(),
        listener: (context, state) {},
        child: BlocBuilder<MessageBloc, MessageState>(
          builder: (context, state) {
            if (state is InitialMessageLoadState) {
              context
                  .read<MessageBloc>()
                  .add(GetMessageFromFirebase(widget.emailMerchant));
            }
            if (state is EmpetyMsgState) {
              return const Center(
                child: Text('-Today-'),
              );
            }
            if (state is SuccesLoadMessageState) {
              final documentStream = FirebaseFirestore.instance
                  .collection('chatrooms')
                  .doc(state.uidChatrooms)
                  .snapshots();
              return StreamBuilder<DocumentSnapshot>(
                  stream: documentStream,
                  builder: (BuildContext c,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: const Text("Loading"));
                    }
                    List listmsg = snapshot.data!['message'];
                    return ListView.builder(
                      controller: _listController,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (c, i) {
                        return Align(
                          alignment: (snapshot.data!['message'][i]['sender'] ==
                                  state.uid)
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: (snapshot.data!['message'][i]['sender'] ==
                                  state.uid)
                              ? Container(
                                  margin: EdgeInsets.only(
                                      right: 5,
                                      left: MediaQuery.of(context).size.width *
                                          0.4,
                                      top: 2),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 12),
                                  decoration: const BoxDecoration(
                                    color: ColorsWeplant.colorPrimary,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      bottomRight: Radius.circular(15),
                                      bottomLeft: Radius.circular(15),
                                    ),
                                  ),
                                  child: Text(
                                    snapshot.data!['message'][i]['msg'],
                                    style: GoogleFonts.aBeeZee(
                                        color: Colors.white),
                                  ),
                                )
                              : Container(
                                  margin: EdgeInsets.only(
                                      left: 5,
                                      right: MediaQuery.of(context).size.width *
                                          0.4,
                                      top: 2),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.8),
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(15),
                                      bottomRight: Radius.circular(15),
                                      bottomLeft: Radius.circular(15),
                                    ),
                                  ),
                                  child: Text(
                                    snapshot.data!['message'][i]['msg'],
                                    style: GoogleFonts.aBeeZee(
                                        color: Colors.white),
                                  ),
                                ),
                        );
                      },
                      itemCount: listmsg.length,
                    );
                  });
            }

            return const Center(
              child: CircularProgressIndicator(
                color: ColorsWeplant.colorPrimary,
              ),
            );
          },
        ),
      ),
    );
  }

  Container _buildTextfield() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: ColorsWeplant.colorMsgBorder,
                  ),
                  borderRadius: BorderRadius.circular(13)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    keyboardType: TextInputType.multiline,
                    style: GoogleFonts.aBeeZee(fontSize: 14),
                    cursorColor: ColorsWeplant.colorPrimary,
                    decoration: InputDecoration(
                      constraints: const BoxConstraints(),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 13),
                      border: InputBorder.none,
                      isDense: true,
                      hintText: 'Your message',
                      hintStyle: GoogleFonts.aBeeZee(
                          fontSize: 14, color: Colors.black.withOpacity(0.4)),
                    ),
                    autofocus: false,
                    maxLines: null,
                    controller: _textMsgController,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          BlocBuilder<MessageBloc, MessageState>(builder: (context, state) {
            return GestureDetector(
              onTap: () {
                if (_textMsgController.text.trim().isNotEmpty) {
                  FocusScope.of(context).unfocus();
                  context.read<MessageBloc>().add(PostMessageToFirebase(
                      _textMsgController.text.trim().toString(),
                      widget.emailMerchant));
                  _listController.animateTo(
                      _listController.position.maxScrollExtent,
                      duration: Duration(milliseconds: 800),
                      curve: Curves.easeOut);
                  _textMsgController.clear();
                }
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: ColorsWeplant.colorPrimary,
                    borderRadius: BorderRadius.circular(12)),
                child: Image.asset(
                  'assets/send_icon.png',
                  width: 20,
                  height: 20,
                ),
              ),
            );
          })
        ],
      ),
    );
  }

  BlocBuilder<ProfilBloc, UserState> _buildHeader() {
    return BlocBuilder<ProfilBloc, UserState>(builder: (context, state) {
      if (state is InitialUserState) {
        context
            .read<ProfilBloc>()
            .add(getUserByEmailFirestore(widget.emailMerchant));
      }
      if (state is SuccesLoadUserState) {
        return Container(
          padding: const EdgeInsets.only(top: 15, right: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: SvgPicture.asset(
                  'assets/icons/chevron-left.svg',
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(23),
                child: (state.photourl.isEmpty)
                    ? Container(
                        width: 40,
                        height: 40,
                        color: ColorsWeplant.colorPrimary,
                        child: Center(
                          child: Text(
                            state.name.toString().characters.first,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 24),
                          ),
                        ),
                      )
                    : Image.network(
                        state.photourl,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
              ),
              const SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(state.name),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: ColorsWeplant.colorSecond),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Online',
                        style: GoogleFonts.aBeeZee(color: Colors.black),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        );
      }
      return Container(
        padding: const EdgeInsets.only(top: 15, right: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: SvgPicture.asset(
                'assets/icons/chevron-left.svg',
              ),
            ),
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Colors.grey.withOpacity(0.3)),
            ),
            const SizedBox(
              width: 15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: 17,
                  decoration:
                      BoxDecoration(color: Colors.grey.withOpacity(0.3)),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: 15,
                  decoration:
                      BoxDecoration(color: Colors.grey.withOpacity(0.3)),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
