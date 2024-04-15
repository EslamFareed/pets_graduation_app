import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pets_graduation_app/cubits/adoption/adoption_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

class PetDetailsScreen extends StatefulWidget {
  PetDetailsScreen({super.key, required this.item});

  Map item;

  @override
  State<PetDetailsScreen> createState() => _PetDetailsScreenState();
}

class _PetDetailsScreenState extends State<PetDetailsScreen> {
  @override
  void initState() {
    AdoptionCubit.get(context).getOwnerData(widget.item["ownerId"]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        title: Text(widget.item["name"]),
      ),
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            height: MediaQuery.sizeOf(context).height * .4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: NetworkImage(widget.item["picture"]),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 20),
            child: Text(
              "${widget.item["name"]}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(10),
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.deepPurple[50],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Gender",
                        style: TextStyle(color: Colors.grey[500], fontSize: 18),
                      ),
                      Text(
                        widget.item["gender"],
                        style: const TextStyle(
                            color: Colors.deepPurple, fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(10),
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.deepPurple[50],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Age",
                        style: TextStyle(color: Colors.grey[500], fontSize: 18),
                      ),
                      Text(
                        "${widget.item["age"]} years",
                        style: const TextStyle(
                            color: Colors.deepPurple, fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(10),
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.deepPurple[50],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Category",
                        style: TextStyle(color: Colors.grey[500], fontSize: 18),
                      ),
                      Text(
                        widget.item["category"]["name"],
                        style: const TextStyle(
                            color: Colors.deepPurple, fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Card(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Text("${widget.item["desc"]}"),
            ),
          ),
          const SizedBox(height: 25),
          BlocBuilder<AdoptionCubit, AdoptionState>(
            builder: (context, state) {
              return state is LoadingGetOwnerDataState
                  ? const Center(child: CircularProgressIndicator())
                  : Container(
                      margin: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(
                                  AdoptionCubit.get(context)
                                      .ownerData["picture"],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(AdoptionCubit.get(context)
                                      .ownerData["name"]),
                                  const Text("Pet Owner"),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () async {
                                  Uri numberUri;
                                  numberUri = Uri(
                                      scheme: 'tel',
                                      path: AdoptionCubit.get(context)
                                          .ownerData["phone"]);

                                  if (!await launchUrl(numberUri)) {
                                    throw 'Could not launch $numberUri';
                                  }
                                },
                                icon: const Icon(Icons.call),
                              ),
                              IconButton(
                                onPressed: () async {
                                  await launchUrl(
                                    Uri.parse(
                                      //'https://wa.me/1234567890' //you use this url also
                                      'whatsapp://send?phone=${AdoptionCubit.get(context).ownerData["phone"]}',
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.chat),
                              )
                            ],
                          )
                        ],
                      ),
                    );
            },
          ),
          BlocConsumer<AdoptionCubit, AdoptionState>(
            listener: (context, state) {
              if (state is SuccessAdoptPetState) {
                Navigator.pop(context);
              }
            },
            builder: (context, state) {
              return state is LoadingAdoptPetState
                  ? const Center(child: CircularProgressIndicator())
                  : Container(
                      margin: const EdgeInsets.all(20),
                      child: MaterialButton(
                        onPressed: () {
                          AdoptionCubit.get(context).adoptPet(widget.item);
                        },
                        color: Colors.deepPurple,
                        height: 50,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        child: const Text("Adopt Me"),
                      ),
                    );
            },
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
