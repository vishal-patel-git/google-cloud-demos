import {Knex} from 'knex';
import {DatabaseError} from 'pg';
import {
  Client as GoogleMapsClient,
  PlaceInputType,
} from '@googlemaps/google-maps-services-js';
import {Vendor} from '../../models';
import {AlreadyExistsError} from '../../../errors';

interface VendorsServiceOptions {
  db: Knex;
  googleMaps: {
    client: GoogleMapsClient;
    apiKey: string;
  };
}

class VendorsService {
  private readonly vendorsTable = 'vendors';

  constructor(private readonly options: VendorsServiceOptions) {}

  async createVendor(name: string, address: string): Promise<Vendor> {
    const {data: findPlaceFromTextResponseData} =
      await this.options.googleMaps.client.findPlaceFromText({
        params: {
          key: this.options.googleMaps.apiKey,
          input: address,
          inputtype: PlaceInputType.textQuery,
        },
      });

    const googlePlaceId = findPlaceFromTextResponseData.candidates[0].place_id;

    if (!googlePlaceId) {
      throw new RangeError('Address not found');
    }

    const {data: placeDetailsResponseData} =
      await this.options.googleMaps.client.placeDetails({
        params: {
          key: this.options.googleMaps.apiKey,
          place_id: googlePlaceId,
        },
      });

    try {
      const [vendor] = await this.options
        .db<Vendor>(this.vendorsTable)
        .insert({
          name,
          address: placeDetailsResponseData.result.formatted_address,
          googlePlaceId,
        })
        .returning('*');

      return vendor;
    } catch (err) {
      if (err instanceof DatabaseError) {
        if (err.code === '23505') {
          if (err.constraint === 'vendors_name_unique') {
            throw new AlreadyExistsError('Vendor already exists');
          }
        }
      }

      throw err;
    }
  }

  async getVendor(id: string): Promise<Vendor> {
    const [vendor] = await this.options
      .db<Vendor>(this.vendorsTable)
      .where({id});

    return vendor;
  }

  async deleteVendor(id: string): Promise<void> {
    await this.options.db(this.vendorsTable).where('id', id).del();
  }
}

export {VendorsService};
