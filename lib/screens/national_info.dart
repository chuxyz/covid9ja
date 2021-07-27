import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:covid9ja/base/base_states.dart';
import 'package:covid9ja/cubits/national_info_cubit.dart';
import 'package:covid9ja/custom_widgets/statistic_card.dart';
import 'package:covid9ja/custom_widgets/virus_loader.dart';
import 'package:covid9ja/screens/state_details.dart';
import 'package:covid9ja/states/national_info_state.dart';

class NationalInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<NationalInfoCubit, BaseState>(
        bloc: BlocProvider.of<NationalInfoCubit>(context),
        builder: (context, state) {
          if (state is NationalInfoLoadingState) return VirusLoader();
          if (state is BaseErrorState) return buildErrorMessage(context);
          if (state is NationalInfoLoadedState)
            return ListView(
              children: <Widget>[
                if (state.preferredState != null)
                  ListTile(
                    leading: CircleAvatar(
                      child: Icon(
                        Icons.home,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                    title: Text(state.preferredState!.stateName),
                    subtitle: Text(
                        '${state.preferredState!.stateCases} -- ${state.preferredState!.stateDeaths}'),
                    trailing: Icon(Icons.arrow_right),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => StatesDetailPage(
                          stateName: state.preferredState!.stateName,
                        ),
                      ),
                    ),
                  ),
                StatisticCard(
                  color: Colors.pink,
                  text: 'Samples Tested',
                  icon: Icons.thermostat,
                  stats: state.info!.samplesTested!,
                ),
                StatisticCard(
                  color: Colors.orange,
                  text: 'Confirmed cases',
                  icon: Icons.timeline,
                  stats: state.info!.confirmedCases!,
                ),
                StatisticCard(
                  color: Colors.blue[600]!,
                  text: 'Active cases',
                  icon: Icons.repeat,
                  stats: state.info!.activeCases!,
                ),
                StatisticCard(
                  color: Colors.green,
                  text: 'Discharged Cases',
                  icon: Icons.whatshot,
                  stats: state.info!.dischargedCases!,
                ),
                StatisticCard(
                  color: Colors.red,
                  text: 'Total deaths',
                  icon: Icons.airline_seat_individual_suite,
                  stats: state.info!.deaths!,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Card(
                    elevation: 4.0,
                    child: ListTile(
                      leading: Icon(
                        Icons.sentiment_very_dissatisfied,
                        color: Colors.red,
                      ),
                      title: Text('Death percentage'),
                      trailing: Text(
                        state.stats!.deathPercentage!.toStringAsFixed(2) + ' %',
                        style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Card(
                    elevation: 4.0,
                    child: ListTile(
                      leading: Icon(
                        Icons.sentiment_very_satisfied,
                        color: Colors.green,
                      ),
                      title: Text('Recovery percentage'),
                      trailing: Text(
                        state.stats!.dischargedPercentage!.toStringAsFixed(2) +
                            ' %',
                        style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
              ],
            );
          return Container();
        },
      ),
    );
  }

  Center buildErrorMessage(context) {
    return Center(
      child: Text(
        'Unable to fetch data',
        style:
            Theme.of(context).textTheme.headline6!.copyWith(color: Colors.grey),
      ),
    );
  }
}
