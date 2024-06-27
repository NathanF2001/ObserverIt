import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:observerit/entities/Agent.dart';

class AgentService {
  FirebaseFirestore db = FirebaseFirestore.instance;
  addAgent(DocumentReference viewReference, Agent agent) async {

    await viewReference.collection("agent").add(agent.toJson());
  }

  updateExpression(DocumentReference agentReference, String expression) async {
    await agentReference.update({
      "expression": expression,
      "hasNewContent": false,
    });
  }

  updateViewContent(DocumentReference agentReference) async {
    await agentReference.update({
      "hasNewContent": false,
    });
  }

  deleteAgent(DocumentReference agentReference) async {
    await agentReference.delete();
  }

}
